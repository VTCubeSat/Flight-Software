$ErrorActionPreference="Stop"
$boardDirectories = "data_board", "dev_board", "sensor_board" 
For ($i = 0; $i -lt $boardDirectories.Length; $i++) {
    cd $boardDirectories[$i]
    cmake ./
    cd ../
}
