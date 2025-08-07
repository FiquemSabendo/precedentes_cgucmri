BEGIN { FS = ";" }
{
    url = $NF
    filename = $(NF-1)
    cmd = "echo \"" url "\" | md5sum | cut -d\" \" -f1"
    cmd | getline hash
    close(cmd)
    print "--no-clobber \"" url "\" -O \"data/raw/files/" hash "__" filename "\""
}
EOF
