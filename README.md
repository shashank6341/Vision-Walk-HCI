<br/>
<p align="center">
  <h3 align="center">Vision Walk</h3>

  <p align="center">
    This repository contains the complete source code for the Vision Walk system.
    <br/>
    <br/>
    <a href="https://github.com/shashank6341/Vision Walk HCI">View Demo</a>
    .
    <a href="https://github.com/shashank6341/Vision-Walk-HCI/issues">Report Bug</a>
    .
    <a href="https://github.com/shashank6341/Vision-Walk-HCI/issues">Request Feature</a>
  </p>
</p>

## Table Of Contents

* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [Authors](#authors)

## About The Project

![180](https://github.com/shashank6341/Vision-Walk-HCI/assets/8446697/d48c9116-773e-42d7-9bcb-211c94a05122)

Three components of Vision Walk are:

* iOS end user system that automatically captures the user environment and describes it.
* A python server that processes and compresses the received uncompressed JPEG image.
* An Inference server: BLIP captioning model that processed the image and returns the caption.

## Built With

The development of the application was made possible by following tools and technologies.

* [Swift](https://developer.apple.com/swift/)
* [Python](https://www.python.org/)
* [Xcode](https://developer.apple.com/xcode/)
* [Instrument](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use)
* [BLIP Image Captioning Large](https://huggingface.co/Salesforce/blip-image-captioning-large)
* [Google MLKit Translate](https://developers.google.com/ml-kit/language/translation/ios)
* [Postman](https://www.postman.com/)
* [ngrok](https://ngrok.com/)
* [Amazon Web Services](https://aws.amazon.com/)
## Getting Started

To get a local copy up and running follow these steps.

### Prerequisites

1. Setup a Virtual Environment (venv)

```sh
python3 -m venv <venv-name>
```

2. Activate the virtual environment

```sh
source <venv-name>/bin/activate
```

3. Install the required packages

```sh
pip install transformers torch pillow flask
```

4. Install Brew utility

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

5. Install cocoapods

```sh
brew install cocoapods
```

6. Install ngrok

```sh
brew install ngrok/ngrok/ngrok
```

7. Install Xcode, command line tools and the iOS SDK.

8. Generate Ngrok auth key from the ngrok website.

9. Enter your ngrok API key
    
```sh
ngrok config add-authtoken <your-auth-key>
```

### Installation

1. Clone this repository.

```sh
https://github.com/shashank6341/Vision-Walk-HCI.git
```

2. Navigate to the repository

3. Install PODS in the iOS folder.

```sh
pods install
```

4. Run the project with Vision Walk.xcworkspace
   
5. 

```sh
git clone https://github.com/your_username_/Project-Name.git
```

3. Start the blip_caption_server.py server

```sh
python3 blip_caption_server.py
```

4. Expose your local python server through ngrok.

```JS
ngrok http <port-no>
```

## Usage

The system is in experimental stage and can infer incorrect results. Please test the system in safe environments.

Launch the system and it will automatically capture the surrounding environments. Test across various scenarios and raise a new issues incase you encounter any issues or have improvements suggestion.

** Add system demo images _For more examples, please refer to the [Documentation](https://example.com)_**

## Roadmap

See the [open issues](https://github.com/shashank6341/Vision Walk HCI/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.
* If you have suggestions for adding or removing projects, feel free to [open an issue](https://github.com/shashank6341/Vision Walk HCI/issues/new) to discuss it, or directly create a pull request after you edit the *README.md* file with necessary changes.
* Please make sure you check your spelling and grammar.
* Create individual PR for each suggestion.

## Branch Pattern

** Create a new branch for each new feature or a sub-feature for easy debugging. **

- feature/{feature-name}
- Once tested and working as expected.
- Create a PR from feature to main.

### Creating A Pull Request

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Authors

* **[Shashank Verma](https://github.com/shashank6341/)** - *Concordia University*
* **[Ayushi Chaudhary](https://github.com/shashank6341/)** - *Concordia University*
* **[Het Dalal](https://github.com/shashank6341/)** - *Concordia University*
* **[Khyati Bareja](https://github.com/shashank6341/)** - *Concordia University*
* **[Kenish Halani](https://github.com/shashank6341/)** - *Concordia University*
* **[Riddhi Bhuva](https://github.com/shashank6341/)** - *Concordia University*
* **[Rohit Rohit](https://github.com/shashank6341/)** - *Concordia University*
