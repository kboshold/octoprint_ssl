
if ! command -v git &> /dev/null
then
    apt-get install -y git 
fi

# get latest version (no the best to run at, root... YOLO)
/usr/bin/git clone --depth 1 https://github.com/kpalatzky/octoprint_ssl /opt/octoprint_ssl

cd /opt/octoprint_ssl
cp ./settings_template.env settings.env

echo "-----------------------------------------"
echo ""
echo "For the next step you need to set some settings."

while true; do
    read -p "Do you want to do this immediately and then continue? [yn]" yn
    case $yn in
        [Yy]* ) edit settings.env; break;;
        [Nn]* ) echo "Edit 'settings.env' and continue by running 'sudo ./scripts/setup.sh'"; exit;;
    esac
done

./scripts/setup.sh