// Max size of inputs
global encodN: u32 = 100;
global charN: u32 = 100;
global lenN: u32 = 10;
global depN: u32 = 10;

//main func
fn main(encodIp:[u32;encodN],charIp:[u32;charN],lenIp:[u32;lenN],depIp:[u32;depN]) {
    //encoded input in decimal form
    let mut encodArray: [u32;encodN] = [0;encodN];
    for i in 0..encodN {
        encodArray[i] = (encodIp[i]/10)*16+(encodIp[i]%10);
    }
    //charArray,lenArray,depArray to compare with the charIp,lenIp,depIp
    let mut charArray: [u32;charN] = [0;charN];
    let mut lenArray: [u32;lenN] = [0;lenN];
    let mut depArray: [u32;depN] = [0;depN];
    //single byte
    if(encodArray[0] <= 127) {
        charArray[0] = encodArray[0];
        lenArray[0] = 1;
        depArray[0] = 0;
    }
    if(encodArray[0] >= 128){
        if(encodArray[0] <= 183) {
            lenArray[0] = encodArray[0] - 128;
            depArray[0] = 1;
            for i in 0..lenArray[0] {
                charArray[i] = encodArray[i+1];
            }
        }
    }
    if encodArray[0] <= 191 {

        // length_of_length
        let len_of_len: u32 = encodArray[0] - 183;

        let mut actLen: u32 = 0;

        // Read actual length (big-endian)
        for i in 0..len_of_len {
            actLen = actLen * 256 + encodArray[1 + i];
        }

        lenArray[0] = actLen;
        depArray[0] = 1;

        // Copy string bytes
        for i in 0..actLen {
            charArray[i] = encodArray[1 + len_of_len + i];
        }
    }


}