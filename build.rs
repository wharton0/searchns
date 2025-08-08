fn main() {
    #[cfg(windows)]
    {
        if let Err(e) = winres::WindowsResource::new()
            .set_manifest_file("app.manifest")
            .compile() {
            eprintln!("Warning: Could not compile Windows resources: {}", e);
        }
    }
}