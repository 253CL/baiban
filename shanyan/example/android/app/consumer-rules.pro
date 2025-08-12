-dontwarn com.cmic.gen.sdk.**
-keep class com.cmic.gen.sdk.**{*;}
-dontwarn cn.com.chinatelecom.account.**
-keep class cn.com.chinatelecom.account.**{*;}
-keep class com.unicom.online.account.shield.** {*;}
-keep class com.unicom.online.account.kernel.** {*;}
-keep class com.chuanglan.shanyan_sdk.**{*;}
-dontwarn org.bouncycastle.**
-keep class org.bouncycastle.** { *;}
-keep public class * extends android.app.Activity
-keep  class com.chuanglan.shanyan_sdk.OneKeyLoginManager{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.tool.CheckAuthTool{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.listener.**{
    public  *;
}

