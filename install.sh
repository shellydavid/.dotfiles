
# ---------------------------------------------------------------------------
# Run "source install.sh" to get things set up in a new environment
# ---------------------------------------------------------------------------


# Install XCode CLI Tools, bypassing GUI intervention
#   https://gist.github.com/mokagio/b974620ee8dcf5c0671f
#   https://apple.stackexchange.com/questions/107307/how-can-i-install-the-command-line-tools-completely-from-the-command-line
xcode-select -p &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "🛠️ Installing XCode CLI tools ------------"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
    softwareupdate -i "$PROD" --verbose
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
else
    echo "🛠️ XCode CLI tools is already installed ------------"
fi


# Install Homebrew
#   https://brew.sh/
command -v brew &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "🍺 Installing Homebrew ------------"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "🍺 Homebrew is already installed ------------"
fi


# Install packages in Brewfile
echo "📦 Installing packages via Homebrew ------------"
brew bundle


# Install Miniconda
#   https://www.anaconda.com/docs/getting-started/miniconda/install#macos
#   System-level installation for miniconda requires a GUI. The CLI installer, utilized here, is user-level
command -v conda &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "🐍 Installing Miniconda ------------"
    mkdir -p ~/miniconda3

    if [[ $(uname -m) == "x86_64" ]]; then
        echo "❕Installing for Intel chip ------------"
        curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda3/miniconda.sh
    else
        echo "❕Installing for Apple Silicon chip ------------"
        curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
    fi

    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    source ~/miniconda3/bin/activate
    # Typically, a miniconda CLI installation should have a "conda init --all" command here
    # However, this will either:
    #   - create a .zshrc file if it doesnt exist (which can later cause conflicts with stow symlinking)
    #   - add conda init code to an existing .zshrc file, even if the file already has this code
    # "conda init --all" is excluded here, and instead, zsh/.zshrc already contains the conda init code
    # I am not using the other shells - bash, tcsh, and xonsh - that conda initializes with "conda init --all"
else
    echo "🐍 Miniconda is already installed ------------"
fi  


# P10k
#   Manual install method: https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#manual
command -v p10k &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "📦 Installing Powerlevel10K ------------"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
    echo "📦 Powerlevel10K is already installed ------------"
fi

echo "🔠 Copying fonts for Powerlevel10K ------------"
cp ./iTerm2Fonts/*.ttf ~/Library/Fonts/


# Symlink dotfiles with gnu stow
echo "🛠️ Linking dotfiles with stow ------------"
stow fzf
stow zsh
stow p10k


# Oh My Zsh
#   https://ohmyz.sh/#install
#   Installing at the end, since it auto-restarts the terminal and looks for a .zshrc file
#   By default, it makes a backup of your .zshrc file and creates a brand new one with only OMZ stuff in it
#   --keep-zsh prevents this, so we can keep the .zshrc we symlinked above (which already contains OMZ stuff)
#   see: https://github.com/ohmyzsh/ohmyzsh/blob/3e7ef0182f59c7990a52cf6ec2981adb56d5b368/tools/install.sh#L35C7-L35C17
echo "📦 Installing Oh My Zsh ------------"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
