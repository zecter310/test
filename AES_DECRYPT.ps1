$password = "Imf!nfo#2025Sec$"
$salt = [Byte[]](0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08)
$iterations = 10000
$keySize = 32   
$ivSize = 16 

$deriveBytes = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($password, $salt, $iterations)
$key = $deriveBytes.GetBytes($keySize)
$iv = $deriveBytes.GetBytes($ivSize)

# List of input files
$inputFiles = @(
    "B:\\IMF-Secret.enc",
    "B:\\IMF-Mission.enc"
)

foreach ($inputFile in $inputFiles) {
	$outputFile = $inputFile -replace '\.enc$', '.pdf'

	$aes = [System.Security.Cryptography.Aes]::Create()
	$aes.Key = $key
	$aes.IV = $iv
	$aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
	$aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7

	$decryptor = $aes.CreateDecryptor()

	$encryptedBytes = [System.IO.File]::ReadAllBytes($inputFile)

	$outStream = New-Object System.IO.FileStream($outputFile, [System.IO.FileMode]::Create)
	$cryptoStream = New-Object System.Security.Cryptography.CryptoStream($outStream, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)

	$cryptoStream.Write($encryptedBytes, 0, $encryptedBytes.Length)
	$cryptoStream.FlushFinalBlock()

	$cryptoStream.Close()
	$outStream.Close()
	
}