function ccc
    if grep -q '!' /etc/ca-certificates.conf
        return 1
    end

    printf "\ndeselect the following certificates? (y/n)\n\n"

    echo "
    '/ePKI/ s/^/!/;
    /emSign/ s/^/!/;
    /GDCA/ s/^/!/;
    /GTS/ s/^/!/;
    /CFCA/ s/^/!/;
    /Amazon/ s/^/!/;
    /D-TRUST/ s/^/!/;
    /TeleSec/ s/^/!/;
    /TWCA/ s/^/!/;
    /Tugra/ s/^/!/;
    /Camerfirma/ s/^/!/;
    /TUBITAK/ s/^/!/;
    /Hellenic/ s/^/!/;
    /Hongkong/ s/^/!/;
    /Lux/ s/^/!/;
    /QuoVadis/ s/^/!/;
    /Nederlanden/ s/^/!/;
    /Swiss/ s/^/!/;
    /thawte/ s/^/!/;
    /Izenpe/ s/^/!/;
    /DigiNotar/ s/^/!/'
    " | cut -c5- | tr -d '\n' \
    | xargs -I{} -p sudo sed -i {} /etc/ca-certificates.conf

    printf "\n"

    if grep '!' /etc/ca-certificates.conf
        sudo update-ca-certificates --fresh
    end
end
