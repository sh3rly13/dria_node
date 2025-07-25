# DRIA Node Automatic Installation Script (macOS)

This script is designed to automate the installation of [Ollama](https://ollama.com/), [Gemma](https://ollama.com/library/gemma), and [DRIA Compute Node](https://dria.co/) with a single command on computers running **macOS (Apple Silicon & Intel)**.

It simplifies the installation process, checks for necessary dependencies (like Homebrew), attempts to resolve common network errors, and guides the user step-by-step. It is optimized especially for systems with low RAM.

## 🎯 What Does It Do?

This script performs the following operations sequentially and automatically:

1.  **Homebrew Check and Installation:** If Homebrew package manager is not installed on your system, it automatically installs it and adds it to your shell configuration.
2.  **Ollama Installation:** Installs the latest version of Ollama via Homebrew.
3.  **Gemma Model Download:** Downloads the `gemma:4b` model, which is required for DRIA and consumes fewer resources, from the Ollama library. It includes a second attempt and cache clearing mechanism against potential DNS and network errors.
4.  **DRIA Compute Node Installation:** Downloads and installs DRIA's official launcher (`dkn-compute-launcher`).
5.  **Start DRIA Node:** At the final step of the installation, it starts the DRIA node and guides you for the initial configuration.

## ⚙️ Minimum System Requirements

-   **Operating System:** macOS 11.0 (Big Sur) or newer.
-   **Architecture:** Apple Silicon (M1, M2, M3, M4 series) or Intel processor Macs.
-   **RAM:** Minimum **8 GB RAM**. 16 GB or more is recommended.
-   **Disk Space:** Minimum **15 GB** free disk space (for Homebrew, Ollama, Gemma model, and DRIA).
-   **Internet Connection:** An active and stable internet connection is required to download packages and the model during installation.

## 🚀 How to Use?

To start the installation, all you need to do is copy the command below, paste it into the **Terminal** application on your Mac, and press `Enter`.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sh3rly13/dria_node/main/dria_low.sh)"
```

### Installation Process

1.  When you run the command, the script will start and notify you of the steps.
2.  During Homebrew or DRIA installation, you may be asked for your **administrator (sudo) password**. It will not be visible on the screen when you type your password; this is normal. Type it and press `Enter`.
3.  At the end of the installation, the DRIA launcher will run and ask you to enter your `wallet private key` and select a model for the first configuration.
4.  **Model Selection:** Make sure to select the **`gemma:4b`** model from the list. The script will have already downloaded this model.

## ⚠️ Possible Issues and Solutions

-   **Error: `Permission denied`**
    -   **Solution:** You will not get this error when running this script with the single-line `curl` command above. If you are manually downloading and running the file, you need to give execute permission with `chmod +x dria_low.sh` command.

-   **Error: Gemma model could not be downloaded.**
    -   **Solution:** The script attempts to resolve the issue by clearing the DNS cache. If the problem persists, as stated by the script, temporarily change your DNS server to `8.8.8.8` (Google) or `1.1.1.1` (Cloudflare) and try again.

-   **Problem: Installation finished but DRIA does not see the `gemma:4b` model.**
    -   **Solution:** Follow the instructions at the end of the script:
        1.  First, pull the model manually:
            ```bash
            ollama pull gemma:4b
            ```
        2.  Then restart the DRIA configuration:
            ```bash
            dkn-compute-launcher setup
            ```

## 💬 Contact

If you encounter a problem during installation or have a suggestion, you can contact us through the following channels:

-   **X (Twitter):** [@sh3rly13](https://twitter.com/sh3rly13)
-   **GitHub Issues:** You can open a new issue in the project's [Issues](https://github.com/sh3rly13/dria_node/issues) section.


