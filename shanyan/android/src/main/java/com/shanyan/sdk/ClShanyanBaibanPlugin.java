package com.shanyan.sdk;

import android.content.Context;
import android.util.Log;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.AuthenticationExecuteListener;
import com.chuanglan.shanyan_sdk.listener.GetPhoneInfoListener;
import com.chuanglan.shanyan_sdk.listener.InitListener;
import com.chuanglan.shanyan_sdk.listener.LoginAuthListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * ClShanyanBaibanPlugin
 * flutter与Android通信桥梁
 */
public class ClShanyanBaibanPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    final String shanyan_code = "code";//返回码
    final String shanyan_message = "message";//描述
    String shanyan_innerCode = "innerCode"; //内层返回码
    String shanyan_innerDesc = "innerDesc"; //内层事件描述
    String shanyan_token = "token"; //token
    String shanyan_number = "number";
    String shanyan_telecom = "telecom";
    String shanyan_protocolName = "protocolName";
    String shanyan_protocolUrl = "protocolUrl";


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "shanyan");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            if ("printConsoleEnable".equals(call.method)) {
                // 设置debug模式
                setDebug(call);
            } else if ("getShanyanVersion".equals(call.method)) {
                //获取SDK版本
                result.success("2.4.5.6");
            } else if ("init".equals(call.method)) {
                //初始化
                init(call, result);
            } else if ("getPrePhoneInfo".equals(call.method)) {
                //预取号
                getPhoneInfo(result);
            } else if ("authentication".equals(call.method)) {
                //获取token
                loginAuth(result);
            } else if ("localAuthentication".equals(call.method)) {
                //本机号校验
                startAuthentication(result);
            } else if ("clearScripCache".equals(call.method)) {
                //清空预取号缓存
                OneKeyLoginManager.getInstance().clearScripCache(context);
            } else if ("getScripCache".equals(call.method)) {
                //获取预取号是否有缓存
                result.success(OneKeyLoginManager.getInstance().getScripCache(context));
            } else if ("setPreGetPhonenumberTimeOut".equals(call.method)) {
                //设置预取号超时时间
                setTimeOutForPreLogin(call);
            } else if ("getOperatorType".equals(call.method)) {
                //获取运营商类型
                result.success(OneKeyLoginManager.getInstance().getOperatorType(context));
            } else if ("getImEnable".equals(call.method)) {
                //是否获取IMEI
                getImEnable(call);
            } else if ("getMaEnable".equals(call.method)) {
                //是否获取Mac
                getMaEnable(call);
            } else if ("getIEnable".equals(call.method)) {
                //是否获取ip
                getIEnable(call);
            } else if ("setFullReport".equals(call.method)) {
                //是否上报日志
                setFullReport(call);
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setFullReport(MethodCall call) {
        boolean imEnable = call.argument("report");
        OneKeyLoginManager.getInstance().setFullReport(imEnable);
    }

    private void getIEnable(MethodCall call) {
        boolean iEnable = call.argument("IEnable");
        OneKeyLoginManager.getInstance().getIEnable(iEnable);
    }

    private void getMaEnable(MethodCall call) {
        boolean maEnable = call.argument("MaEnable");
        OneKeyLoginManager.getInstance().getMaEnable(maEnable);
    }

    private void getImEnable(MethodCall call) {
        boolean imEnable = call.argument("ImEnable");
        OneKeyLoginManager.getInstance().getImEnable(imEnable);
    }

    private void setTimeOutForPreLogin(MethodCall call) {
        int timeOut = call.argument("preGetPhoneTimeOut");
        OneKeyLoginManager.getInstance().setTimeOutForPreLogin(timeOut);
    }

    private void startAuthentication(final Result result) {
        OneKeyLoginManager.getInstance().startAuthentication(new AuthenticationExecuteListener() {
            @Override
            public void authenticationRespond(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    if (2000 == code) {
                        code = 1000;
                        map.put(shanyan_token, jsonObject.optString("token"));
                        map.put(shanyan_innerCode, code);
                        map.put(shanyan_innerDesc, "获取token成功");
                        map.put(shanyan_message, "token success");
                    } else {
                        map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                        map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                        map.put(shanyan_message, jsonObject.optString("message"));
                    }
                    map.put(shanyan_code, code);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void loginAuth(final Result result) {
        OneKeyLoginManager.getInstance().loginAuth(new LoginAuthListener() {
            @Override
            public void getLoginTokenStatus(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                map.put(shanyan_code, code);
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    if (1000 == code) {
                        map.put(shanyan_token, jsonObject.optString("token"));
                        map.put(shanyan_innerCode, code);
                        map.put(shanyan_innerDesc, "获取token成功");
                        map.put(shanyan_message, "token success");
                    } else {
                        map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                        map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                        map.put(shanyan_message, jsonObject.optString("message"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void getPhoneInfo(final Result result) {
        OneKeyLoginManager.getInstance().getPhoneInfo(new GetPhoneInfoListener() {
            @Override
            public void getPhoneInfoStatus(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                if (1022 == code) {
                    code = 1000;
                }
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                    map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                    map.put(shanyan_number, jsonObject.optString("number"));
                    map.put(shanyan_telecom, jsonObject.optString("telecom"));
                    map.put(shanyan_protocolName, jsonObject.optString("protocolName"));
                    map.put(shanyan_protocolUrl, jsonObject.optString("protocolUrl"));
                    map.put(shanyan_code, code);
                    map.put(shanyan_message, jsonObject.optString("message"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void init(MethodCall call, final Result result) {
        String appId = call.argument("appId");
        OneKeyLoginManager.getInstance().init(context, appId, new InitListener() {
            @Override
            public void getInitStatus(int code, String msg) {
                Map<String, Object> map = new HashMap<>();
                if (1022 == code) {
                    code = 1000;
                }
                try {
                    JSONObject jsonObject = new JSONObject(msg);
                    map.put(shanyan_innerCode, jsonObject.optInt("innerCode"));
                    map.put(shanyan_innerDesc, jsonObject.optString("innerDesc"));
                    map.put(shanyan_code, code);
                    map.put(shanyan_message, jsonObject.optString("message"));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                result.success(map);
            }
        });
    }

    private void setDebug(MethodCall call) {
        boolean debug = call.argument("enable");
        OneKeyLoginManager.getInstance().setDebug(debug);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


}
