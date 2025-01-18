
# Emacs Installation Script for Ubuntu

This project provides a Bash script to completely remove any existing installations of Emacs from an Ubuntu system and install the latest stable version of Emacs. The script ensures that all traces of previous Emacs versions (installed via APT or Snap) are removed and installs Emacs cleanly from source or APT.

## Features

- Removes any existing Emacs installations (installed via APT or Snap).
- Cleans up configuration files and directories related to Emacs.
- Installs the latest stable version of Emacs using APT or from source.
- Verifies the installation and provides usage instructions.

## Prerequisites

- An Ubuntu-based system.
- Sudo privileges.

## How to Use

1. **Clone this repository** to your local machine:

   ```bash
   git clone https://github.com/your-username/emacs-installation-script.git
   cd emacs-installation-script
   ```

2. **Make the script executable**:

   ```bash
   chmod +x install_emacs.sh
   ```

3. **Run the script**:

   ```bash
   sudo ./install_emacs.sh
   ```

   The script will:
   - Uninstall any existing Emacs installations.
   - Clean up Emacs-related files.
   - Install Emacs either from the APT repository or by compiling from source.

4. **Confirm installation**:

   After running the script, you can check that Emacs is installed correctly by running:

   ```bash
   emacs --version
   ```

## Script Details

The script performs the following tasks:

1. **Uninstall Previous Versions**:
   - Removes any existing Emacs installations installed via APT:
     ```bash
     sudo apt-get purge emacs emacs-*
     ```
   - Removes any Snap installations of Emacs:
     ```bash
     sudo snap remove emacs
     ```

2. **Remove Configuration Files**:
   - Deletes any lingering configuration files and directories related to Emacs:
     ```bash
     sudo rm -rf ~/.emacs.d ~/.config/emacs ~/.emacs
     ```

3. **Install New Version**:
   - Installs the latest version of Emacs via APT:
     ```bash
     sudo apt-get update
     sudo apt-get install emacs
     ```

   Optionally, if you prefer to compile Emacs from source, the script can download the source and compile it:
   ```bash
   sudo apt-get install build-essential libgtk-3-dev libgnutls28-dev
   wget http://ftp.gnu.org/gnu/emacs/emacs-<version>.tar.gz
   tar -xvf emacs-<version>.tar.gz
   cd emacs-<version>
   ./configure
   make
   sudo make install
   ```

## Known Issues

- On some systems, certain dependencies might need to be installed manually when compiling from source. Check the output of the script and install any missing packages if necessary.
- Ensure that there are no running Emacs processes during installation.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues and pull requests if you would like to contribute to the project.

## Contact

For any questions, please reach out to [your-email@example.com](mor@zahavi.xyz).