#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit
fi

echo "Removing any existing Emacs installation..."

# Remove previous Emacs installation and related packages
sudo apt-get purge -y emacs emacs-common emacs-nox emacs-gtk emacs-lucid
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Remove user-specific configuration files
echo "Removing Emacs configuration files..."
rm -rf ~/.emacs.d ~/.emacs

echo "Installing required dependencies for native compilation..."

# Install necessary build tools and libraries for native compilation
sudo apt-get update
sudo apt-get install -y build-essential gcc libgccjit-10-dev libjansson-dev \
    libgnutls28-dev libxml2-dev libgif-dev libtiff-dev libpng-dev libjpeg-dev \
    libxpm-dev libncurses5-dev libharfbuzz-dev libfreetype6-dev libxft-dev \
    libacl1-dev libdbus-1-dev libgmp-dev libselinux1-dev libsystemd-dev libjson-c-dev \
    autoconf automake texinfo

echo "Cloning Emacs repository..."

# Clone the latest Emacs repository from Git
cd 
git clone https://git.savannah.gnu.org/git/emacs.git
cd emacs

# Checkout the latest stable branch (emacs-29 for this example)
git checkout emacs-29

echo "Configuring and building Emacs with native compilation support..."

# Configure the build with native compilation support
./autogen.sh
./configure --with-native-compilation --with-json --with-modules --with-x --with-gnutls

# Build and install Emacs
make -j$(nproc)
sudo make install

echo "Emacs has been installed with native compilation."

# Create the ~/.emacs.d directory if it doesn't exist
mkdir -p ~/.emacs.d

# Create a basic init.el with performance optimizations and useful packages
echo "Creating init.el configuration file..."

cat <<EOL > ~/.emacs.d/init.el
;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install 'use-package' for easier package management
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Enable Native Compilation (Emacs 28+)
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil)
  (setq comp-deferred-compilation t))

;; Performance tweaks
;; Increase the garbage collection threshold for better performance
(setq gc-cons-threshold (* 50 1000 1000)) ; 50MB threshold

;; Disable unnecessary startup screen
(setq inhibit-startup-message t)

;; Install useful packages
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Enable line numbers globally
(global-display-line-numbers-mode t)

;; Optimize native compilation for speed
(when (featurep 'native-compile)
  (setq native-comp-speed 3))

;; Final optimization: reset garbage collection threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)))) ; 2MB after startup

EOL

echo "Configuration file (init.el) created at ~/.emacs.d/init.el"

echo "Installation and setup complete. You can now launch Emacs by running 'emacs'."
