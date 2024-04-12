# Vision Walk Image Captioning Server Setup

- CD to your Directory
- Run: python3 -m venv LLM
- activate LLM venv by: source LLM/bin/activate
- In that directory with LLM (venv) activated run: pip install transformers torch pillow flask
- Once installed, run: python image_captioning.py. The application will run on localhost port 8090.
- To expose this locally hosted server for testing on iOS, use ngrok.
- Install ngrock from brew or there package.
- Create an account and get your API key, (Instructions on the website).
- ngrok http #portno of the localhosted application that you want to expose. *This will generate a string of web address use that*

# Vision Walk iOS Setup

- Install Xcode from App Store, It will ask you automatically to install the required SDK of iOS.
- Clone this project.
- CD to iOS and run Vision Walk.xcodeproj.
- Make changes in the CameraVC.swift
- Reachibility.swift is to check the internet connection.



<br/>
<p align="center">
  <h3 align="center">Vision Walk</h3>

  <p align="center">
    This repository contains the complete source code for the Vision Walk system.
    <br/>
    <br/>
    <a href="https://github.com/shashank6341/Vision Walk HCI"><strong>Explore the docs »</strong></a>
    <br/>
    <br/>
    <a href="https://github.com/shashank6341/Vision Walk HCI">View Demo</a>
    .
    <a href="https://github.com/shashank6341/Vision-Walk-HCI/issues">Report Bug</a>
    .
    <a href="https://github.com/shashank6341/Vision-Walk-HCI/issues">Request Feature</a>
  </p>
</p>

![Contributors](https://img.shields.io/github/contributors/shashank6341/Vision Walk HCI?color=dark-green) ![Issues](https://img.shields.io/github/issues/shashank6341/Vision Walk HCI) ![License](https://img.shields.io/github/license/shashank6341/Vision Walk HCI) 

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
* [Acknowledgements](#acknowledgements)

## About The Project

![Screen Shot](images/screenshot.png)

Vision Walk Description

Three components of Vision Walk are:

* Your time should be focused on creating something amazing. A project that solves a problem and helps others
* You shouldn't be doing the same tasks over and over like creating a README from scratch
* You should element DRY principles to the rest of your life :smile:

A list of commonly used resources that I find helpful are listed in the acknowledgements.

## Built With

The development of the application was made possible by following tools and technologies.

* [Swift](https://developer.apple.com/swift/)
* [Python](https://www.python.org/)
* [Xcode](https://developer.apple.com/xcode/)
* [Instrument](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use)
* [BLIP Image Captioning Large](https://huggingface.co/Salesforce/blip-image-captioning-large)
* [Google MLKit Translate](https://developers.google.com/ml-kit/language/translation/ios)
* [Postman](https://www.postman.com/)
* [nrok](https://ngrok.com/)
* [Amazon Web Services](https://aws.amazon.com/)
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

* npm

```sh
npm install npm@latest -g
```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)

2. Clone the repo

```sh
git clone https://github.com/your_username_/Project-Name.git
```

3. Install NPM packages

```sh
npm install
```

4. Enter your API in `config.js`

```JS
const API_KEY = 'ENTER YOUR API';
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

## Acknowledgements

* []()
* []()
* []()
