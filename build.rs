use std::path::Path;

fn main() {
    // 只在 Windows 平台编译资源
    if cfg!(target_os = "windows") {
        println!("cargo:warning=Windows platform detected, processing resources...");
        
        // 方法1: 尝试使用 embed-resource
        if Path::new("app.rc").exists() {
            println!("cargo:warning=Using embed-resource with app.rc");
            embed_resource::compile("app.rc", embed_resource::NONE);
        } else {
            // 方法2: 使用 winres
            println!("cargo:warning=Using winres");
            
            let mut res = winres::WindowsResource::new();
            
            // 设置图标
            if Path::new("icon.ico").exists() {
                println!("cargo:warning=Setting icon");
                res.set_icon("icon.ico");
            }
            
            // 设置版本信息 - 使用更明确的方法
            println!("cargo:warning=Setting version information");
            res.set("FileDescription", "Excel Serial Number Search Tool");
            res.set("ProductName", "Excel Serial Search Tool");
            res.set("CompanyName", "Wharton Wang");
            res.set("FileVersion", "1.4.0.0");
            res.set("ProductVersion", "1.4.0.0");
            res.set("OriginalFilename", "searchns.exe");
            res.set("InternalName", "searchns");
            res.set("LegalCopyright", "Copyright (C) 2025 Wharton Wang");
            res.set("Comments", "Excel serial number search tool");
            
            // 设置版本号
            res.set_version_info(winres::VersionInfo::PRODUCTVERSION, 0x0001000400000000);
            res.set_version_info(winres::VersionInfo::FILEVERSION, 0x0001000400000000);
            
            // 编译资源
            println!("cargo:warning=Compiling Windows resources with winres...");
            match res.compile() {
                Ok(_) => {
                    println!("cargo:warning=✅ winres compilation successful");
                }
                Err(e) => {
                    println!("cargo:warning=❌ winres compilation failed: {}", e);
                }
            }
        }
    }
    
    // 重新运行条件
    println!("cargo:rerun-if-changed=icon.ico");
    println!("cargo:rerun-if-changed=app.rc");
    println!("cargo:rerun-if-changed=build.rs");
}