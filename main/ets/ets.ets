
import { preferences } from '@kit.ArkData';
import { abilityAccessCtrl, Context, Permissions, UIAbility } from '@kit.AbilityKit';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { AddFormMenuItem } from '@kit.ArkUI';
import router from '@ohos.router'
import { bundleManager } from '@kit.AbilityKit';
import { emitter } from '@kit.BasicServicesKit';

const contextall = getContext(this);

export class mydata {
  dataPreferences: preferences.Preferences | null = null;
  context: Context | null = getContext(this);
  _Init: () => Promise<string> = () => {
    let that = this;
    return new Promise((succ, err) => {
      if (that.dataPreferences != null) {
        return;
      }
      console.log("applog:数据库初始化")
      let options: preferences.Options = { name: 'myStore' };
      that.dataPreferences = preferences.getPreferencesSync(that.context, options);
      succ("success")
    })
  }
  set: (key: string, value: string) => Promise<string> = (key, value) => {
    return new Promise((succ, err) => {
      if (this.dataPreferences) {
        this.dataPreferences.putSync(key, value);
        this.dataPreferences.flush((err2: BusinessError) => {
          if (err2) {
            console.error(`applog:Failed to flush. Code:${err2.code}, message:${err2.message}`);
            return;
          }
          console.log(`applog:数据保存成功：${key}：${value}`);
          succ(`数据保存成功：${key}：${value}`);
        })
      } else {
        console.log(`applog:数据保存失败：${key}：${value}`);
        err(`数据保存失败：${key}：${value}`);
      }
    });
  }
  get: (key: string) => Promise<string> = (key) => {
    return new Promise((succ, err) => {
      if (this.dataPreferences) {
        let val = "" + this.dataPreferences.getSync(key, 'null');
        console.log(`applog:数据获取成功：${key}:${val}`);
        succ(val);
      } else {
        console.log(`applog：数据获取失败`);
      }
    })
  }
  get2 = (key: string) => {
    if (this.dataPreferences) {
      let val = "" + this.dataPreferences.getSync(key, 'null');
      console.log(`applog:数据获取成功2：${key}:${val}`);
      return val;
    } else {
      console.log(`applog：数据获取失败2`);
      return "null";
    }
  }
  delete: (key: string) => Promise<string> = (key) => {
    return new Promise((succ, err) => {
      if (this.dataPreferences) {
        this.dataPreferences.deleteSync(key);
        this.dataPreferences.flush((err2: BusinessError) => {
          if (err2) {
            console.error(`applog:Failed to flush. Code:${err2.code}, message:${err2.message}`);
            return;
          }
          console.log("applog:数据删除成功");
          succ(`数据删除成功`);
        })
      }
    })
  }

  removecache=()=>{
    let options: preferences.Options = { name: 'myStore' };
    preferences.removePreferencesFromCacheSync(this.context,options);
    this.dataPreferences = preferences.getPreferencesSync(this.context,options);
  }

  constructor(t?: boolean, context?: Context) {
    if (!t) {
      this._Init();
    }
    if (!context) {
      this.context = contextall;
    } else {
      this.context = context;
    }
  }
}

export function toast(text: string, call = () => {
}, time: number = 2000) {
  let s = time || 2000;
  promptAction.showToast({
    message: text,
    duration: s,
    bottom: 120
  });
  if (call) {
    setTimeout(() => {
      call();
    }, s)
  }
}

export function bigtoast(title:string,text: string,call=()=>{}) {
  AlertDialog.show(
    {
      title: title,
      message: text,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0, dy: -20
      },
      gridCount: 3,
      confirm: {
        value: '确认',
        action: () => {
          call();
        }
      },
      cancel: () => {
      }
    }
  )
}

export function te(text: string) {
  AlertDialog.show(
    {
      title: '错误',
      message: text,
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0, dy: -20
      },
      gridCount: 3,
      confirm: {
        value: '确认',
        action: () => {

        }
      },
      cancel: () => {
      }
    }
  )
}


export function tm(text: string, call1 = () => {
}, call2 = () => {
}) {
  promptAction.showDialog({
    title: '提示',
    message: text,
    buttons: [
      {
        text: '确认',
        color: '#0AA344'
      },
      {
        text: '取消',
        color: '#F20C00',
      }
    ],
  })
    .then(data => {
      if (data.index == 0) {
        call1();
      } else {
        if (call2) {
          call2();
        }
      }
    })
    .catch((e: string) => {
      console.log(e);
    })
}


export class page {
  go = (url: string, data?: object, t?: boolean) => {
    if (!t) {
      router.pushUrl({
        url: "pages/" + url,
        params: data
      })
    } else {
      router.replaceUrl({
        url: "pages/" + url,
        params: data
      })
    }
  }
  back = (url?: string, data?: object) => {
    if (!url || url == "") {
      router.back();
    } else {
      router.back({
        url: "pages/" + url,
        params: data
      });
    }
  }
  get = (key: string): string => {
    let obj = router.getParams() as Record<string, string>
    return obj[key];
  }
}

export class Day {
  get = (to: number = 0, fs = true): string => {
    let cha = to;
    let day1 = new Date();
    day1.setTime(day1.getTime() + 24 * 60 * 60 * 1000 * cha);
    let s1 = day1.getFullYear() + "-" + (day1.getMonth() + 1) + "-" + day1.getDate();
    if (fs == true) {
      let dd1 = s1.split('-');
      for (let i = 0; i < dd1.length; i++) {
        let obj = dd1[i];
        if (obj.length == 1) {
          obj = "0" + obj;
        }
        dd1[i] = obj;
      }
      s1 = dd1.join('-');
    }
    return s1;
  }
  cha = (sDate1: string, sDate2: string = ""): number => {
    let dateSpan = 0,
      iDays = 0;
    let d1 = sDate1;
    let d2 = sDate2 == "" ? this.get() : sDate2;
    let sd1 = Date.parse(d1);
    let sd2 = Date.parse(d2);
    dateSpan = sd2 - sd1;
    dateSpan = Math.abs(dateSpan);
    iDays = Math.floor(dateSpan / (24 * 3600 * 1000));
    return iDays
  }
  which = (date: string, days: number): string => {
    let n1 = new Date(date);
    let nd = n1.valueOf();
    nd = nd + days * 24 * 60 * 60 * 1000;
    let n2 = new Date(nd);
    let y = n2.getFullYear();
    let m = n2.getMonth() + 1;
    let d = n2.getDate();
    let mon = "";
    if (m <= 9) {
      mon = "0" + m
    } else {
      mon = "" + m;
    }
    let day = "";
    if (d <= 9) {
      day = "0" + d;
    } else {
      day = "" + d;
    }
    let cdate = y + "-" + mon + "-" + day;
    return cdate;
  }
}

class Dydata {
  t: string = ""
}

export class Dingyue {
  set = (id: number, data: Dydata = { t: "" }) => {
    let innerEvent: emitter.InnerEvent = { eventId: id }
    let eventData: emitter.EventData = {
      data
    }
    emitter.emit(innerEvent, eventData)
  }
  add = (id: number, callback: (data: string) => void) => {
    let innerEvent: emitter.InnerEvent = { eventId: id }
    emitter.on(innerEvent, data => {
      console.log("applog:em" + JSON.stringify(data))
      if (data) {
        callback("t");
      } else {
        callback("s");
      }
    })
  }
}

export function _Newarray(arr: Array<object>) {
  let list = arr;
  let list2: Array<object> = [];
  for (let i = 0; i < list.length; i++) {
    list2.push(list[i]);
  }
  return list2;
}

let _Getquanxian: (qx: Array<Permissions>) => Promise<string> = (qx) => {
  return new Promise((succ, err) => {
    console.log("applog:" + qx[0])
    let manager = abilityAccessCtrl.createAtManager();
    manager.requestPermissionsFromUser(contextall,
      qx)
      .then(() => {
        console.log("applog:aaaa")
        succ("a");
      })
      .catch((err: BusinessError) => {
        console.log('applog:error:' + JSON.stringify(err));
      });
  })
}


let _Checkquanxian: (qx: Array<Permissions>) => Promise<string> = (qx) => {
  return new Promise((succ, error) => {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION | bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    try {
      bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
        let tokenid:number = data['appInfo']['accessTokenId'];
        let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
        atManager.checkAccessToken(tokenid, qx[0]).then((data: abilityAccessCtrl.GrantStatus) => {
          let res = JSON.stringify(data);
          console.log("applog" + res)
          if(res == "0"){
            succ("true")
          }else{
            succ("false")
          }
        }).catch((err: BusinessError) => {
          error();
          console.error(`checkAccessToken fail, err->${JSON.stringify(err)}`);
        });

      }).catch((err: BusinessError) => {
        error();
        console.log("checkAccessTokenddd")
      });
    } catch (err) {
      let message = (err as BusinessError).message;
    }
  })
}



export {
  _Getquanxian,
  _Checkquanxian
}

export function _Suiji(min:number,max:number){
  return ~~(Math.random() * (max - min + 1) + min);
}