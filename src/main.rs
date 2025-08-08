use calamine::{open_workbook, DataType, Reader, Xlsx, Xls};
use std::fs;
use std::io::{self, Write};
use std::path::{Path, PathBuf};

// 搜索结果结构体
#[derive(Debug, Clone)]
struct SearchResult {
    file_name: String,
    sheet_name: String,
    row_index: u32,
    row_data: Vec<String>,
    header_row: Vec<String>, // 存储表头信息
}

// Excel文件处理器
struct ExcelSearcher {
    search_directory: PathBuf,
}

impl ExcelSearcher {
    fn new(directory: &str) -> Self {
        Self {
            search_directory: PathBuf::from(directory),
        }
    }

    // 获取目录下所有Excel文件（包括子目录）
    fn get_excel_files(&self) -> io::Result<Vec<PathBuf>> {
        let mut excel_files = Vec::new();
        
        if !self.search_directory.exists() {
            return Err(io::Error::new(
                io::ErrorKind::NotFound,
                format!("目录不存在: {}", self.search_directory.display())
            ));
        }

        self.scan_directory(&self.search_directory, &mut excel_files)?;
        Ok(excel_files)
    }

    // 递归扫描目录
    fn scan_directory(&self, dir: &Path, excel_files: &mut Vec<PathBuf>) -> io::Result<()> {
        for entry in fs::read_dir(dir)? {
            let entry = entry?;
            let path = entry.path();
            
            if path.is_file() {
                if let Some(extension) = path.extension() {
                    let ext = extension.to_string_lossy().to_lowercase();
                    if matches!(ext.as_str(), "xlsx" | "xls") {
                        excel_files.push(path);
                    }
                }
            } else if path.is_dir() {
                // 递归扫描子目录
                self.scan_directory(&path, excel_files)?;
            }
        }
        Ok(())
    }

    // 在单个Excel文件中搜索
    fn search_in_file(&self, file_path: &Path, serial_number: &str) -> Vec<SearchResult> {
        let file_name = file_path.file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .to_string();

        match file_path.extension().and_then(|ext| ext.to_str()) {
            Some("xlsx") => self.search_xlsx_file(file_path, serial_number, &file_name),
            Some("xls") => self.search_xls_file(file_path, serial_number, &file_name),
            _ => Vec::new(),
        }
    }

    // 处理 XLSX 文件
    fn search_xlsx_file(&self, file_path: &Path, serial_number: &str, file_name: &str) -> Vec<SearchResult> {
        let mut results = Vec::new();
        
        if let Ok(mut workbook) = open_workbook::<Xlsx<_>, _>(file_path) {
            let sheet_names = workbook.sheet_names().to_owned();
            
            for sheet_name in sheet_names {
                if let Some(Ok(range)) = workbook.worksheet_range(&sheet_name) {
                    let rows: Vec<_> = range.rows().collect();
                    if rows.is_empty() {
                        continue;
                    }
                    
                    // 获取表头（第一行）
                    let header_row: Vec<String> = rows[0].iter()
                        .map(|cell| self.cell_to_string(cell))
                        .collect();
                    
                    // 在工作表中搜索（从第二行开始，跳过表头）
                    for (row_idx, row) in rows.iter().enumerate().skip(1) {
                        if row.iter().any(|cell| self.cell_to_string(cell).contains(serial_number)) {
                            let row_data: Vec<String> = row.iter()
                                .map(|cell| self.cell_to_string(cell))
                                .collect();
                            
                            results.push(SearchResult {
                                file_name: file_name.to_string(),
                                sheet_name: sheet_name.clone(),
                                row_index: (row_idx + 1) as u32,
                                row_data,
                                header_row: header_row.clone(),
                            });
                            break;
                        }
                    }
                }
            }
        }
        
        results
    }

    // 处理 XLS 文件
    fn search_xls_file(&self, file_path: &Path, serial_number: &str, file_name: &str) -> Vec<SearchResult> {
        let mut results = Vec::new();
        
        if let Ok(mut workbook) = open_workbook::<Xls<_>, _>(file_path) {
            let sheet_names = workbook.sheet_names().to_owned();
            
            for sheet_name in sheet_names {
                if let Some(Ok(range)) = workbook.worksheet_range(&sheet_name) {
                    let rows: Vec<_> = range.rows().collect();
                    if rows.is_empty() {
                        continue;
                    }
                    
                    // 获取表头（第一行）
                    let header_row: Vec<String> = rows[0].iter()
                        .map(|cell| self.cell_to_string(cell))
                        .collect();
                    
                    // 在工作表中搜索（从第二行开始，跳过表头）
                    for (row_idx, row) in rows.iter().enumerate().skip(1) {
                        if row.iter().any(|cell| self.cell_to_string(cell).contains(serial_number)) {
                            let row_data: Vec<String> = row.iter()
                                .map(|cell| self.cell_to_string(cell))
                                .collect();
                            
                            results.push(SearchResult {
                                file_name: file_name.to_string(),
                                sheet_name: sheet_name.clone(),
                                row_index: (row_idx + 1) as u32,
                                row_data,
                                header_row: header_row.clone(),
                            });
                            break;
                        }
                    }
                }
            }
        }
        
        results
    }






    // 将单元格数据转换为字符串
    fn cell_to_string(&self, cell: &DataType) -> String {
        match cell {
            DataType::Empty => String::new(),
            DataType::String(s) => s.clone(),
            DataType::Float(f) => {
                // 检查是否为整数
                if f.fract() == 0.0 {
                    format!("{:.0}", f)
                } else {
                    f.to_string()
                }
            }
            DataType::Int(i) => i.to_string(),
            DataType::Bool(b) => b.to_string(),
            DataType::DateTime(dt) => format!("{:.2}", dt),
            DataType::Duration(d) => format!("Duration: {:.2}", d),
            DataType::DateTimeIso(dt) => dt.clone(),
            DataType::DurationIso(d) => d.clone(),
            DataType::Error(e) => format!("Error: {:?}", e),
        }
    }

    // 执行搜索
    fn search(&self, serial_number: &str) -> io::Result<Vec<SearchResult>> {
        let excel_files = self.get_excel_files()?;
        let mut all_results = Vec::new();

        if excel_files.is_empty() {
            println!("⚠️  在目录 {} 及其子目录中未找到Excel文件", self.search_directory.display());
            return Ok(all_results);
        }

        println!("🔍 正在搜索 {} 个Excel文件...", excel_files.len());
        
        for file_path in &excel_files {
            let results = self.search_in_file(file_path, serial_number);
            all_results.extend(results);
        }
        
        println!("\n✅ 搜索完成!");
        Ok(all_results)
    }

    // 显示搜索结果
    fn display_results(&self, results: &[SearchResult], serial_number: &str) {
        if results.is_empty() {
            println!("\n❌ 未找到包含序列号 '{}' 的记录", serial_number);
            return;
        }

        println!("\n🎯 找到 {} 个匹配结果:", results.len());
        println!("{}", "=".repeat(80));

        for (index, result) in results.iter().enumerate() {
            println!("\n📋 结果 {} :", index + 1);
            
            // 显示相对路径
            let relative_path = std::env::current_dir()
                .ok()
                .and_then(|current_dir| Path::new(&result.file_name).strip_prefix(&current_dir).ok())
                .map(|p| p.to_string_lossy().to_string())
                .unwrap_or_else(|| result.file_name.clone());
            println!("📁 文件: {}", relative_path);
            println!("📊 工作表: {}", result.sheet_name);
            println!("📍 行号: {}", result.row_index);
            println!("📄 行内容:");
            
            // 显示行数据，使用表头作为列名
            for (col_index, cell_data) in result.row_data.iter().enumerate() {
                if !cell_data.trim().is_empty() {
                    let column_header = result.header_row.get(col_index)
                        .filter(|h| !h.trim().is_empty())
                        .cloned()
                        .unwrap_or_else(|| format!("列 {}", col_index + 1));
                    println!("   {}: {}", column_header, cell_data);
                }
            }
            
            if index < results.len() - 1 {
                println!("{}", "-".repeat(60));
            }
        }
        
        println!("{}", "=".repeat(80));
    }
}

// 获取用户输入
fn get_user_input(prompt: &str) -> String {
    print!("{}", prompt);
    io::stdout().flush().unwrap();
    
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("读取输入失败");
    input.trim().to_string()
}

// 显示程序信息
fn show_header() {
    println!("{}", "=".repeat(60));
    println!("🔎 Excel 序列号查询工具 v1.3");
    println!("🚀 支持 .xlsx 和 .xls 格式文件");
    println!("📁 自动在当前目录及其子目录中搜索");
    println!("📊 显示表头列名而非列号");
    println!("{}", "=".repeat(60));
}

// 主函数
fn main() {
    show_header();
    
    // 直接使用当前目录，不再询问用户
    let current_dir = std::env::current_dir().expect("无法获取当前目录");
    let search_directory = current_dir.to_string_lossy().to_string();
    
    println!("📁 搜索目录: {}", search_directory);
    
    let searcher = ExcelSearcher::new(&search_directory);

    // 主循环
    loop {
        println!("\n{}", "-".repeat(40));
        let serial_number = get_user_input("🔍 请输入要查询的序列号 (输入 'quit' 退出): ");
        
        if serial_number.to_lowercase() == "quit" {
            println!("👋 感谢使用，再见!");
            break;
        }
        
        if serial_number.is_empty() {
            println!("⚠️  序列号不能为空，请重新输入!");
            continue;
        }
        
        // 执行搜索
        match searcher.search(&serial_number) {
            Ok(results) => searcher.display_results(&results, &serial_number),
            Err(e) => eprintln!("❌ 搜索过程中发生错误: {}", e),
        }
    }
}

// 导出搜索结果到文件
#[allow(dead_code)]
fn export_results(results: &[SearchResult], serial_number: &str) {
    let filename = format!("search_results_{}.txt", 
                          serial_number.replace(&['/', '\\', ':', '*', '?', '"', '<', '>', '|'][..], "_"));
    
    match std::fs::write(&filename, format_results_for_export(results, serial_number)) {
        Ok(_) => println!("✅ 结果已导出到: {}", filename),
        Err(e) => eprintln!("❌ 导出失败: {}", e),
    }
}

// 格式化结果用于导出
#[allow(dead_code)]
fn format_results_for_export(results: &[SearchResult], serial_number: &str) -> String {
    let mut output = String::new();
    
    output.push_str("Excel序列号查询结果\n");
    output.push_str(&format!("查询序列号: {}\n", serial_number));
    output.push_str(&format!("找到 {} 个结果\n\n", results.len()));
    output.push_str(&"=".repeat(80));
    output.push_str("\n\n");
    
    for (index, result) in results.iter().enumerate() {
        output.push_str(&format!("结果 {}:\n", index + 1));
        output.push_str(&format!("文件: {}\n", result.file_name));
        output.push_str(&format!("工作表: {}\n", result.sheet_name));
        output.push_str(&format!("行号: {}\n", result.row_index));
        output.push_str("行内容:\n");
        
        for (col_index, cell_data) in result.row_data.iter().enumerate() {
            if !cell_data.trim().is_empty() {
                let column_header = result.header_row.get(col_index)
                    .filter(|h| !h.trim().is_empty())
                    .cloned()
                    .unwrap_or_else(|| format!("列 {}", col_index + 1));
                output.push_str(&format!("  {}: {}\n", column_header, cell_data));
            }
        }
        
        output.push_str("\n");
        if index < results.len() - 1 {
            output.push_str(&"-".repeat(60));
            output.push_str("\n\n");
        }
    }
    
    output
}
