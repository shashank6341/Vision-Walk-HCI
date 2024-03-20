//
//  CameraVC.swift
//  Vision Walk
//
//  Created by Shashank Verma on 10/02/24.
//  Copyright © 2024 Shashank Verma. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

import Alamofire // Network request handler
import MLKitTranslate

enum FlashState {
    case off
    case on
}

class CameraVC: UIViewController {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var photoData: Data?
    
    var flashControlState: FlashState = .off
    
    var speechSynthesizer = AVSpeechSynthesizer()
    var reachability: Reachability?
    var languageSelection: String = "en-US"
    var translationLanguage: String = "en-US"
    var languageChangedString: String = ""
    var isInternetAvailable: Bool = true
    var isInitialLaunch: Bool = true
    
    var englishFrenchTranslator: Translator!
    var captureTimer: Timer?
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var langBtn: UIButton!
    @IBOutlet weak var identificationLbl: UILabel!
    @IBOutlet weak var confidenceLbl: UILabel!
    @IBOutlet weak var roundedLblView: UIView!
    @IBOutlet weak var internetView: UIView!
    @IBOutlet weak var internetLbl: UILabel!
    //    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reachability = Reachability.init()
        
        reachability?.whenReachable = { _ in
            DispatchQueue.main.async {
                self.internetLbl.text! = "Internet Available"
                self.isInternetAvailable = true
            }
        }
        reachability?.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.internetLbl.text! = "Internet Not Available"
                self.isInternetAvailable = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("Couldn't Start Notifier")
        }
        
        setupTranslate()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = roundedLblView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,  // Transparent start color
            UIColor(white: 0.9, alpha: 0.3).cgColor // Light gray with some opacity
        ]
        gradientLayer.locations = [0.0, 1.0]  // Color distribution
        
        // Add a slight blur effect (optional)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        
        // Add blurView with adjusted frame
        let blurFrame = roundedLblView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        blurView.frame = blurFrame
        
        blurView.layer.cornerRadius = 10.0
        
        
        roundedLblView.insertSubview(blurView, at: 0)
        
        // Add the gradient layer on top
        roundedLblView.layer.insertSublayer(gradientLayer, at: 1)
        
        // Optional: Set rounded corners
        roundedLblView.layer.cornerRadius = 10.0  // Adjust corner radius as needed
        
        // Notification for application openings.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToForeground() {
        let message = isInitialLaunch ? "Vision Walked app opened" : "Vision Walked app opened again"
        synthesizeSpeech(fromString: message)
        playHapticFeedback()
        isInitialLaunch = false
    }
    
    func setupTranslate() {
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .french)
        self.englishFrenchTranslator = Translator.translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        
        self.englishFrenchTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                print("Error downloading translation model")
                return
            }
            
            print("Translation model downloaded successfully")
            // Model downloaded successfully. Okay to start translating.
        }
    }
    
    @objc func internetChanged(note: Notification){
        let reachability = note.object as! Reachability
        if reachability.isReachable{
            DispatchQueue.main.async {
                self.internetLbl.text! = "Internet Available"
                self.internetView.backgroundColor = .green
                self.internetViewVisibility()
            }
        }else{
            DispatchQueue.main.async {
                self.internetLbl.text! = "Internet Not Available"
                self.internetView.backgroundColor = .red
                self.internetViewVisibility()            }
        }
        self.synthesizeSpeech(fromString: self.internetLbl.text!)
        playHapticFeedback()
    }
    
    func internetViewVisibility(){
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            
            self.internetView.alpha = 1.0
            
        }) { (finished: Bool) in
            
            self.internetView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            
            self.internetView.alpha = 0.0
            
        }) { (finished: Bool) in
            
            self.internetView.isHidden = true
        }
        
    }
    
    func sendImageToServer(image: UIImage) {
        // URL of your API server
        let apiUrl = "https://d26a-132-205-229-32.ngrok-free.app/caption"
        
        // Load the image from the project bundle
        //        guard let image = UIImage(named: "test2.jpg") else {
        //            print("Error: Unable to load image from bundle")
        //            return
        //        }
        
        // Convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Error: Unable to convert image to data")
            return
        }
        
        // Send the image data as multipart form data using Alamofire
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: apiUrl).responseJSON { response in
            switch response.result {
            case .success(let value):
                // Handle success response
                if let jsonResponse = value as? [String: Any] {
                    if let caption = jsonResponse["caption"] as? String {
                        //                        print("Caption: \(caption)")
                        print("\(caption)")
                        
                        
                        if(self.translationLanguage == "en-US") {
                            
                            self.identificationLbl.text = "\(caption)"
                            self.synthesizeSpeech(fromString: caption)
                        }
                        else {
                            print("Inside French language")
                            self.englishFrenchTranslator.translate(caption) { translatedText, error in
                                guard error == nil, let translatedText = translatedText else { return }
                                
                                // Translation succeeded.
                                self.identificationLbl.text = translatedText
                                self.synthesizeSpeech(fromString: translatedText)
                            }
                        }
                        
                        
                        
                        self.confidenceLbl.text = "Our model is in beta and can make mistakes."
                    } else if let error = jsonResponse["error"] as? String {
                        print("Server Error: \(error)")
                    }
                }
            case .failure(let error):
                // Handle failure response
                print("Error: \(error)")
            }
        }
    }
    
    // Blip Inference Server
    func sendImageToInferenceServer(image: UIImage) {
        print("Inside Send image function")
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            print("Error: Unable to convert image to data")
            return
        }
        
        let url = "https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-large"
        let headers: HTTPHeaders = ["Authorization": "Bearer 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"]
        
        AF.upload(data, to: url, method: .post, headers: headers)
        //            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    //                    print("\(value)")
                    if let jsonArray = value as? [[String: Any]], let firstObject = jsonArray.first, let generatedText = firstObject["generated_text"] as? String {
                        print("Generated Text: \(generatedText)")
                        if(self.translationLanguage == "en-US") {
                            
                            self.identificationLbl.text = "\(generatedText)"
                            self.synthesizeSpeech(fromString: generatedText)
                        }
                        else {
                            print("Inside French language")
                            self.englishFrenchTranslator.translate(generatedText) { translatedText, error in
                                guard error == nil, let translatedText = translatedText else { return }
                                
                                // Translation succeeded.
                                self.identificationLbl.text = translatedText
                                self.synthesizeSpeech(fromString: translatedText)
                            }
                        }
                        self.confidenceLbl.text = "Our system is in beta and can make mistakes."
                    } else {
                        print("Error: Unable to extract generated text from response")
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 503 {
                        print("Service temporarily unavailable. Please try again later.")
                        self.synthesizeSpeech(fromString: "Service temporarily unavailable. Please try again later.")
                    } else {
                        print("Error: \(error)")
                    }
                }
                
            }
    }
    
    func playHapticFeedback()
    {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
        speechSynthesizer.delegate = self
        
        startCaptureTimer()
        
        // Observe UIApplicationDidEnterBackgroundNotification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Observe UIApplicationWillEnterForegroundNotification
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func applicationDidEnterBackground() {
        // Invalidate the timer when the application enters the background
        // print("Invalidated Timer: applicationDidEnterBackground")
        captureTimer?.invalidate()
        captureTimer = nil
    }
    
    @objc func applicationWillEnterForeground() {
        // Reactivate the timer when the application enters the foreground
        // print("Application is in Foreground: applicationWillEnterForeground")
        startCaptureTimer()
    }
    
    func startCaptureTimer() {
        // Ensure the timer is not already running
        guard captureTimer == nil else {
            return
        }
        
        // print("Started captureTimer.")
        // Start the timer to capture photos every 15 seconds
        captureTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(didTapCameraView), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
        //        tap.numberOfTapsRequired = 1
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) == true {
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                //                cameraView.addGestureRecognizer(tap)
                captureSession.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    @objc func didTapCameraView() {
        
        let settings = AVCapturePhotoSettings()
        
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        settings.flashMode = .auto
        
        cameraOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    func resultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        if (!self.isInternetAvailable)
        {
            for classification in results {
                if classification.confidence < 0.5 {
                    var unknownObjectMessage = "Not Sure, Please Try Again."
                    self.identificationLbl.text = unknownObjectMessage
                    self.confidenceLbl.text = "CONFIDENCE: --"
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                    if languageSelection == "en-US" {
                        synthesizeSpeech(fromString: unknownObjectMessage)
                        break
                    } else {
                        unknownObjectMessage = "निश्चित नहीं है, कृपया पुनः प्रयास करें"
                        synthesizeSpeech(fromString: unknownObjectMessage)
                        break
                    }
                    
                    
                } else {
                    let identification = classification.identifier
                    let confidence = Int(classification.confidence * 100)
                    self.identificationLbl.text = identification
                    self.confidenceLbl.text = "CONFIDENCE: \(confidence)%"
                    if languageSelection == "en-US" {
                        let completeSentence = "Looks like a \(identification), \(confidence)% Sure"
                        synthesizeSpeech(fromString: completeSentence)
                        break
                    } else {
                        let completeSentence = "ये है \(identification), \(confidence) प्रतिशत यकीन है"
                        synthesizeSpeech(fromString: completeSentence)
                        break
                    }
                    
                }
            }
        }
    }
    
    func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        //        let speechUtterance = AVSpeechUtterance(string: "Pineapple 100% sure")
        //        speechUtterance.voice = AVSpeechSynthesisVoice(language: "hi-IN")
        print(translationLanguage)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: translationLanguage)
        speechSynthesizer.speak(speechUtterance)
    }
    
    @IBAction func flashBtnWasPressed(_ sender: Any) {
        switch flashControlState {
        case .off:
            flashBtn.setTitle("FLASH ON", for: .normal)
            flashControlState = .on
        case .on:
            flashBtn.setTitle("FLASH OFF", for: .normal)
            flashControlState = .off
        }
    }
    
    @IBAction func langBtnWasPressed(_ sender: Any) {
        
        if languageSelection == "en-US" {
            languageSelection = "hi_IN"
            langBtn.setTitle("Language: Hindi", for: .normal)
            languageChangedString = "भाषा हिंदी में बदल गई"
            synthesizeSpeech(fromString: languageChangedString)
        } else {
            languageSelection = "en-US"
            langBtn.setTitle("Language: English", for: .normal)
            languageChangedString = "Language Changed to English"
            synthesizeSpeech(fromString: languageChangedString)
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake{
            if self.translationLanguage == "en-US" {
                
                self.translationLanguage = "fr-FR"
                
                languageChangedString = "Langue changée en français"
                synthesizeSpeech(fromString: languageChangedString)
            }
            else {
                self.translationLanguage = "en-US"
                
                languageChangedString = "Language changed to english"
                synthesizeSpeech(fromString: languageChangedString)
            }
        }
    }
    
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // Dispose of system sound before capture
        AudioServicesDisposeSystemSoundID(1108)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            
            playHapticFeedback()
            
            photoData = photo.fileDataRepresentation()
            
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
            
            
            if(self.isInternetAvailable)
            {
                // Unwrap the optional image before passing it to the function
                if let unwrappedImage = image {
                    sendImageToServer(image: unwrappedImage)
                } else {
                    print("Error: Captured image is nil")
                }
            }
            else {
                do {
                    let model = try VNCoreMLModel(for: Inceptionv3().model)
                    let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                    let handler = VNImageRequestHandler(data: photoData!)
                    try handler.perform([request])
                } catch {
                    debugPrint(error)
                }
            }
            
            
            captureImageView.isHidden = false
            captureImageView.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                
                self.captureImageView.alpha = 0.0
                
            }) { (finished: Bool) in
                
                self.captureImageView.isHidden = true
            }
        }
    }
}

extension CameraVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        //        self.cameraView.isUserInteractionEnabled = false
        //        self.spinner.isHidden = false
        //        self.spinner.stopAnimating()
    }
}
