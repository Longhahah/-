import http from '@ohos.net.http';
import ResponseCode from '@ohos.net.http';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import { buffer } from '@kit.ArkTS';

let _Imgutil:(img:string)=>Promise<string>=(img)=>{
  return new Promise((succ,err)=>{
    let OutData: http.HttpResponse
    http.createHttp().request(img,
      (error: BusinessError, data: http.HttpResponse) => {
        if (error) {
          console.error(`http reqeust failed with. Code: ${error.code}, message: ${error.message}`);
        } else {
          OutData = data


          let code: http.ResponseCode | number = OutData.responseCode
          if (ResponseCode.ResponseCode.OK === code) {
            let imageData: ArrayBuffer = OutData.result as ArrayBuffer;
            let buf: buffer.Buffer = buffer.from(imageData);
            // ps: data:image/jpg 要根据实际情况调整.
            const base64 = 'data:image/jpg;base64,' + buf.toString('base64', 0, buf.length);
            succ(base64);
          }
        }
      }
    )
  })
}

export {
  _Imgutil
}