import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import {CLResult, CLSDKManager} from '@shanyan/shanyansdk'
import common from '@ohos.app.ability.common';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { LevelMode, window } from '@kit.ArkUI';




/** ShanyanPlugin **/
export default class ShanyanPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private context:Context | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "ShanyanPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "shanyan");
    this.context = binding.getApplicationContext()
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    }else if (call.method == "getShanyanVersion"){
      this.getSDKVersion(result)
    } else if (call.method == "init"){
       this.init(call,result)
    }else if (call.method == 'getPrePhoneInfo'){
       this.preGetPhonenumber(result)
    }else if (call.method == 'authentication'){
       this.quickAuthLoginWithConfigure(call,result)
    }else if (call.method == 'clearScripCache'){
       this.clearScripCache()
    }else if (call.method == 'printConsoleEnable'){
      this.setInitDebug(call)
    }else if (call.method == 'localAuthentication'){
      this.mobileCheckWithLocalPhoneNumberComplete(call,result)
    }else if (call.method == 'setPreGetPhonenumberTimeOut'){
      this.setPreGetPhonenumberTimeOut(call)
    }
    else {
      result.notImplemented()
    }
  }


  getSDKVersion(result:MethodResult){
    const res = CLSDKManager.clSDKVersion()
    result.success(res)
  }

  // 初始化
    async init(call:MethodCall,result: MethodResult){
      CLSDKManager.printConsoleEnable(true)
      let arg:Map<string,ESObject> = call.args as Map<string,ESObject>
      let context = this.context
      let appId = arg.get('appId') as string
      const res:CLResult = await CLSDKManager.init(context,appId)
      result.success(this.completeResultToJson(res))
    }

    // 预取号
    async preGetPhonenumber(result:MethodResult){
      const res:CLResult = await CLSDKManager.preGetPhoneNumber()
      result.success(this.completePhoneResultToJson(res))
    }

    async quickAuthLoginWithConfigure(call:MethodCall,callResult:MethodResult){
      let arg:Map<string,ESObject> = call.args as Map<string,ESObject>
      let pathStack:NavPathStack | undefined= AppStorage.get('cl_pathstack')
      if (pathStack) {
        const res:CLResult = await CLSDKManager.loginAuthForToken(pathStack)
        callResult.success(this.completeResultToJson(res))
      }else {
        console.log('pathStack不存在')
        callResult.error('1004','pathStack不存在','')
      }

    }


    async clearScripCache(){
      CLSDKManager.clearScripCache()
    }

    setInitDebug(call:MethodCall){
      let arg:Map<string,ESObject> = call.args as Map<string,ESObject>
      let enable = arg.get('iEnable') as boolean
      CLSDKManager.printConsoleEnable(enable)
    }
    async mobileCheckWithLocalPhoneNumberComplete(call:MethodCall,callResult:MethodResult){
      const result:CLResult = await CLSDKManager.mobileCheckWithLocalPhoneNumberComplete()
      if (result) {
         callResult.success(this.completeResultToJson(result))
      }else {
         callResult.error('2010','本机号认证获取token出错','')
      }
    }

    setPreGetPhonenumberTimeOut(call:MethodCall){
      let arg:Map<string,ESObject> = call.args as Map<string,ESObject>
      let timeout = arg.get('timeOut') as number
      CLSDKManager.setPreGetPhoneNumberTimeOut(timeout)
    }



  completePhoneResultToJson(completeResult:CLResult):Record<string,ESObject>{
    let phone = ''
    let telecom = ''
    let protocolName = ''
    let protocolUrl = ''
    if (completeResult.data && completeResult.data.get('number')) {
      phone = completeResult.data.get('number')
    }
    if (completeResult.data && completeResult.data.get('telecom')) {
      telecom = completeResult.data.get('telecom')
    }
    if (completeResult.data && completeResult.data.get('protocolName')) {
      protocolName = completeResult.data.get('protocolName')
    }
    if (completeResult.data && completeResult.data.get('protocolUrl')) {
      protocolUrl = completeResult.data.get('protocolUrl')
    }
    let result: Record<string, ESObject> = {
      "code":completeResult.code,
      "message":completeResult.message,
      "innerCode":completeResult.innerCode,
      "innerDesc":completeResult.innerDesc,
      "number":phone,
      "telecom":telecom,
      "protocolName":protocolName,
      "protocolUrl":protocolUrl
    }
    return result
  }


    completeResultToJson(completeResult:CLResult):Record<string,ESObject>{
      let token = ''
      if (completeResult.data && completeResult.data.get('token')) {
        token = completeResult.data.get('token')
      }
      let result: Record<string, ESObject> = {
        "code":completeResult.code,
        "message":completeResult.message,
        "innerCode":completeResult.innerCode,
        "innerDesc":completeResult.innerDesc,
        "token":token
      }
      return result
    }


}

function  mapToObject(map: Map<string, ESObject>): Record<string, ESObject> {
  const obj: Record<string, ESObject> = {};
  map.forEach((value: ESObject, key: string) => {
  if (value instanceof Map) {
    // 递归处理嵌套 Map
    obj[key] = mapToObject(value);
  } else {
    obj[key] = value;
  }
});
return obj;
}


