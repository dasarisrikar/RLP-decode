// Max size of inputs
global encodN: u32 = 100;
global charN: u32 = 100;
global lenN: u32 = 10;
global depN: u32 = 10;

//recursive function to decode the input
fn rec(
    encodArray:[u32;encodN],
    mut charArray:[u32;charN],
    mut lenArray:[u32;lenN],
    mut depArray:[u32;depN],
    encodIndex:u32,
    charIndex:u32,
    depthIndex:u32,
    depth:u32,
    maxLen:u32
) -> ([u32;charN],[u32;lenN],[u32;depN],u32,u32) {
    let mut NewcharIndex = charIndex;
    let mut NewdepthIndex = depthIndex;
    if encodIndex == maxLen {
        //do nothing, just return
    }
    else{
        //single byte
        if encodArray[encodIndex] <= 127 {
            charArray[charIndex] = encodArray[encodIndex];
            lenArray[depthIndex] = 1;
            depArray[depthIndex] = depth;
            NewcharIndex = charIndex + 1;
            NewdepthIndex = depthIndex + 1;
        }
        //short string
        if encodArray[encodIndex] >= 128 {
            if encodArray[encodIndex] <= 183 {
                lenArray[depthIndex] = encodArray[encodIndex] - 128;
                depArray[depthIndex] = depth; 
                for i in 0..lenArray[depthIndex] {
                    charArray[charIndex + i] = encodArray[encodIndex + 1 + i];
                }
                NewcharIndex = charIndex + lenArray[depthIndex];
                NewdepthIndex = depthIndex + 1;
            }
        }
        // long string
        if encodArray[encodIndex] >= 184 {
            if encodArray[encodIndex] <= 191 {
                // length_of_length
                let len_of_len: u32 = encodArray[encodIndex] - 183;
                let mut actLen: u32 = 0;
                // Read actual length (big-endian)
                for i in 0..len_of_len {
                    actLen = actLen * 256 + encodArray[encodIndex + 1 + i];
                }
                lenArray[depthIndex] = actLen;
                depArray[depthIndex] = depth;
                // Copy string bytes
                for i in 0..actLen {
                    charArray[charIndex + i] = encodArray[encodIndex + 1 + len_of_len + i];
                }
                NewcharIndex = charIndex + actLen;
                NewdepthIndex = depthIndex + 1;
            }
        }
        //short list
        if encodArray[encodIndex] >= 192 {
            if encodArray[encodIndex] <= 247 {
                let list_len: u32 = encodArray[encodIndex] - 192;
                let (newCharArray, newLenArray, newDepArray, newCharInd, newDepInd) =
                    rec(encodArray,charArray,lenArray,depArray,
                        encodIndex + 1,
                        charIndex,
                        depthIndex,
                        depth + 1,
                        encodIndex+list_len);
                // Now overwrite
                charArray = newCharArray;
                lenArray = newLenArray;
                depArray = newDepArray;
                NewcharIndex = newCharInd;
                NewdepthIndex = newDepInd;
                //continue with next list item
                let (newCharArray, newLenArray, newDepArray, newCharInd, newDepInd) =
                    rec(encodArray,charArray,lenArray,depArray,
                        encodIndex +list_len + 1,
                        NewcharIndex,
                        NewdepthIndex,
                        depth,
                        maxLen);
                // Now overwrite
                charArray = newCharArray;
                lenArray = newLenArray;
                depArray = newDepArray;
                NewcharIndex = newCharInd;
                NewdepthIndex = newDepInd;
            }
        }
        //long list
        if encodArray[encodIndex] >= 248 {
            if encodArray[encodIndex] <= 255 {
                // length_of_length
                let len_of_len: u32 = encodArray[encodIndex] - 247;
                let mut actLen: u32 = 0;
                // Read actual length (big-endian)
                for i in 0..len_of_len {
                    actLen = actLen * 256 + encodArray[encodIndex + 1 + i];
                }
                let (newCharArray, newLenArray, newDepArray, newCharInd, newDepInd) =
                    rec(encodArray,charArray,lenArray,depArray,
                        encodIndex + 1 + actLen,
                        charIndex,
                        depthIndex,
                        depth + 1,
                        encodIndex+1+actLen);
                // Now overwrite
                charArray = newCharArray;
                lenArray = newLenArray;
                depArray = newDepArray;
                NewcharIndex = newCharInd;
                NewdepthIndex = newDepInd;
                //continue with next list item
                let (newCharArray, newLenArray, newDepArray, newCharInd, newDepInd) =
                    rec(encodArray,charArray,lenArray,depArray,
                        encodIndex +1+actLen,
                        NewcharIndex,
                        NewdepthIndex,
                        depth,
                        maxLen);
                // Now overwrite
                charArray = newCharArray;
                lenArray = newLenArray;
                depArray = newDepArray;
                NewcharIndex = newCharInd;
                NewdepthIndex = newDepInd;
            }
        }
    }
    (charArray,lenArray,depArray,NewcharIndex,NewdepthIndex)
}
//main func
fn main(encodIp:[u32;encodN],charIp:[u32;charN],lenIp:[u32;lenN],depIp:[u32;depN],maxLen:u32) {
    //encoded input in decimal form
    let mut encodArray: [u32;encodN] = [0;encodN];
    for i in 0..encodN {
        encodArray[i] = (encodIp[i]/10)*16+(encodIp[i]%10);
    }
    //charArray,lenArray,depArray to compare with the charIp,lenIp,depIp
    let mut charArray: [u32;charN] = [0;charN];
    let mut lenArray: [u32;lenN] = [0;lenN];
    let mut depArray: [u32;depN] = [0;depN];
    let (charArray,lenArray,depArray,NewCharInd,NewDepInd) =
        rec(encodArray,charArray,lenArray,depArray,0,0,0,0,maxLen);
    
    


}