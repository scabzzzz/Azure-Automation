#!/usr/bin/env bash

DESTFILE="/Library/Application Support/Microsoft/Defender/com.microsoft.wdav.atp.plist"

display_usage_and_exit()
{
    echo "Usage: $0"
    echo "Performs onboarding/offboarding to MDE locally"

    exit 1
}

error_and_exit()
{
    logger -p error "Microsoft ATP: failed to save json file $DESTFILE. Exception occured: $1. Error: $?"
    exit 1
}

while getopts ":h:" options; do         
    case $options in
        *)
        display_usage_and_exit
        ;;
    esac
done

if [ "$EUID" -ne 0 ]; then 
    echo "Re-running as sudo (You may be required to enter a password)"
    sudo /usr/bin/env bash $0 $@
    exit
fi

echo "Generating $DESTFILE"
DESTFILE_DIR=$(dirname "$DESTFILE")
mkdir -p "$DESTFILE_DIR" || error_and_exit "Unable to create directory $DESTFILE_DIR"

cat <<EOM > "$DESTFILE"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1">
            <dict>
                <key>PayloadUUID</key>
                <string>D71143E9-8F41-47EE-8CD2-69495E82C6AC</string>
                <key>PayloadType</key>
                <string>com.microsoft.wdav.atp</string>
                <key>PayloadOrganization</key>
                <string>Microsoft</string>
                <key>PayloadIdentifier</key>
                <string>D71143E9-8F41-47EE-8CD2-69495E82C6AC</string>
                <key>PayloadDisplayName</key>
                <string>WDATP configuration settings</string>
                <key>PayloadDescription</key>
                <string/>
                <key>PayloadVersion</key>
                <integer>1</integer>
                <key>PayloadEnabled</key>
                <true/>
                <key>AllowUserOverrides</key>
                <true/>
                <key>OrgId</key>
                <string>664f48da-d82a-4c57-a4df-b92187835158</string>
                <key>OnboardingInfo</key>
                <string>{"body":"{\"previousOrgIds\":[],\"orgId\":\"664f48da-d82a-4c57-a4df-b92187835158\",\"geoLocationUrl\":\"https://winatp-gw-cus3.microsoft.com/\",\"datacenter\":\"CentralUs3\",\"vortexGeoLocation\":\"US\",\"version\":\"1.45\"}","sig":"/AHvXN5IGhh+1u8GtwNKmPmcxkXYfTvjRtdGBdpj5xqAgd92QLScDAkXif4v9jIQbjinESlCoyIe+X6tSHUsnuW6h6S5zv3GKzFDFEvD8K1SG0pXwyGF886FkatQ8hNouhaHJC3+LPYpHgnnPoo9S3R8XAo4sydC2BJJENINSUw9CbjTddS6iQTVWTgh4tIyfGw9pFR2eG26CLxr+Eu+Zw2ma3FlicbWWNlrrmvv9y8aS18ldWq12QtF4uvcEVtwAz79wd/TQHA+/h+xaDohHnXrVUMLzI0lK0ESrTWGktIlHPHfUJSoY6ODcYvBICt+JZGcIQJ3duhIG6aLhfFdFg==","sha256sig":"pvhHfMwDXBaXI+aIBONm52tR8CeLFWEdGOOv0TIMtvJpi4YpSQE1I5SxMoBCsVVFyR5b1idmxHM+2WC4QikxEGMzuHEkE+YbsAda7n85CkYyVFF1Z9bfXUFyPQfsL0hUaQkjKSJeE4rJ4GXk2w0T4StwswP35PNol2k48o2Wz+fQzCQekkVV6LuLgGXCcqYeLU8rOwvts8TbYIjy6XJ2SLcB0SeTSkMXvPtdr/zpowgZyl7Wz3XjEniRRnNnEtNzrQxx33nDHHHRDaaoyyGYnojLDQhhyoie++1xX5i/PN2IGab+VG1K+bSocqqEFXOkkxKh1SnSVs6BaCgTUrPirw==","cert":"MIIFgzCCA2ugAwIBAgITMwAAAgKh9Eww96dTKQAAAAACAjANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgU2VjdXJlIFNlcnZlciBDQSAyMDExMB4XDTIzMDIyMzE5NDMxMVoXDTI0MDIyMzE5NDMxMVowHjEcMBoGA1UEAxMTU2V2aWxsZS5XaW5kb3dzLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALjedJ4XjZjlasoG2AecXnOQ4T04l1VeqhjrfJ6PvQf1oiI8HuZ1l0l6Szgvl0yi2dehEL0llDAaqAjk/T5wFF6fYA4JfXriOTx83zsq9IKnjVZ34Jzbfkvy9lHTu+giCDkzs/Eo560rpJXl5VlGsQpzzYCkWZ6ZJQ1eDfrPqu3SISi+Na0cxE3nGpqG5mtMckdrsrzwrDuKm4qAQaGsGlfEoR1IVtCNydnuL+FmPK9+j/nzJ4eHqIzr8Euz3laW+UGvf2r7Z5n19IFT7sJuqjTeG5RC+LODHQFl/knG9sRQaae+zqkmPvMT7m4tx2/HJsyJsatOp38GJ3f+Qqy8/3UCAwEAAaOCAVgwggFUMA4GA1UdDwEB/wQEAwIFIDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAeBgNVHREEFzAVghNTZXZpbGxlLldpbmRvd3MuY29tMB0GA1UdDgQWBBSz+8TlAUJCn2MDTDONsD1p+meKaTAfBgNVHSMEGDAWgBQ2VollSctbmy88rEIWUE2RuTPXkTBTBgNVHR8ETDBKMEigRqBEhkJodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNTZWNTZXJDQTIwMTFfMjAxMS0xMC0xOC5jcmwwYAYIKwYBBQUHAQEEVDBSMFAGCCsGAQUFBzAChkRodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY1NlY1NlckNBMjAxMV8yMDExLTEwLTE4LmNydDANBgkqhkiG9w0BAQsFAAOCAgEAoKKuLorfzJWL6HsBsAMwocM295/IkS5FVTASKTdZsqF9Q0Dvngx5YRMY1ljznNhyUYLXzLFKom2oVHlUmhbgY0zVkK798Mv6MEscMxxiQ9o/s8DxxdCBmnwswg3ERR8Q6RCqclsp8LEGUmQXJiLA5EFZSNMa2qlHQS3LoaEz5saVTvt6UihfwclY/F5MJOtlj+IJyv3lIX5Gdzi5wlCp7gMhOZmwDh2RCvulWT3wMmyz2lNT/vkEb8IJ7oKr+/oj7wPTmCZ0k20wyDIa9QbVBMX0CiotY5RHkHZnzkpi4lWc6f2MXsqMRjP6iyyylWQ1Itn+rKjHeBuLAIfqQWuvfT1kyH5IM6QXQw8DS6Wto0hjIx9epUOPscxOr/Qli8zOYJ3i/h3j9/x41hArCnla/ISf5hDVPm0/LTDfFZWxuvMjjnkk+HmsEpq5oaV/Pmuh8ml47kXWddJrAJGDPtEZNqpjO+ObH0P7kb/t5feK1mTmSsKwMJVTnlIUuubbRM2ZeQ0kkZKSUhVjMvO6YfoR6f2EkrCXWlr9VPYtro+pAy4cVMARDW1aOPPLyxk/7cLL+YUTYbEOw+D+bQXEr00AsjmzucvRN2paejjBSH8A+8k+alPobReH88Ktlo4GkqbK9S3vSqH4zJC3GcIJ+mQBxcUlmKWbC5lRo9btWPcTEOU=","chain":["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"]}</string>
</dict>
</plist>
EOM

if [ $? -ne 0 ]; then
    error_and_exit "Unable to save file $DESTFILE: $?"
fi

logger -p warning "Microsoft ATP: succeeded to save json file $DESTFILE"
