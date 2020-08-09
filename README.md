<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Requirements](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [License](#license)
* [Contact](#contact)

<!-- ABOUT THE PROJECT -->
## About The Project
A script that builds a docker container with CUDA & Ubuntu 18.04 and runs a little program through it to test the installation of OpenCV with (or without) CUDA support.

### Requirements

* CUDA 10.0/10.2/11.0
* Docker

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites
* Install CUDA
* Install Docker

### Installation
 
1. Clone the repository
```sh
git clone https://github.com/tachillon/ImageProcessing-ComputerVision-MachineLearning-Docker
```
2. Go to the cloned directory
```sh
cd ./ImageProcessing-ComputerVision-MachineLearning-Docker
```
3. Give permission to execute launch.sh
```sh
chmod +x launch.sh
```
<!-- USAGE EXAMPLES -->
## Usage

```sh
bash launch.sh --with_cuda=1
```

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Achille-Tâm GUILCHARD - achilletamguilchard@gmail.com