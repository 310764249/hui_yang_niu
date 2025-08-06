# Flutter & Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Gson (if used)
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Retrofit (if used)
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-dontwarn retrofit2.**

# Prevent stripping of model classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# AndroidX
-dontwarn androidx.**
-keep class androidx.** { *; }

# App specific entities
-keep class com.netease.** { *; }
-keep interface com.netease.** { *; }
-dontwarn com.netease.**

# 保留反射入口类（如果你设置了 MainActivity）
-keep class com.baiyihui.douliao.MainActivity { *; }

# 保留 Flutter 插件调用相关
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# 忽略常见警告
-ignorewarnings

-keep class com.netease.lava.** {*;}
-keep class com.netease.yunxin.** {*;}
# Flutter 基础保留
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# 避免 MainActivity 被混淆
-keep class com.saiente.intellectualbreed.MainActivity { *; }

# JPush 示例（如果用到了极光推送）
-keep class cn.jpush.** { *; }
-dontwarn cn.jpush.**

# Baidu LBS 示例（你用了百度地图）
-keep class com.baidu.** { *; }
-dontwarn com.baidu.**

# 若使用 FlutterLocalNotifications
-keep class com.dexterous.** { *; }

-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**