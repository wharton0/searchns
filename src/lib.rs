// 库文件，用于测试和模块化

pub mod searcher {
    use calamine::DataType;

    #[derive(Debug, Clone, PartialEq)]
    pub struct SearchResult {
        pub file_name: String,
        pub sheet_name: String,
        pub row_index: u32,
        pub row_data: Vec<String>,
        pub header_row: Vec<String>,
    }

    pub fn cell_to_string(cell: &DataType) -> String {
        match cell {
            DataType::Empty => String::new(),
            DataType::String(s) => s.clone(),
            DataType::Float(f) => {
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

    #[cfg(test)]
    mod tests {
        use super::*;

        #[test]
        fn test_cell_to_string() {
            assert_eq!(cell_to_string(&DataType::Empty), "");
            assert_eq!(cell_to_string(&DataType::String("test".to_string())), "test");
            assert_eq!(cell_to_string(&DataType::Int(42)), "42");
            assert_eq!(cell_to_string(&DataType::Float(3.14)), "3.14");
            assert_eq!(cell_to_string(&DataType::Float(3.0)), "3");
            assert_eq!(cell_to_string(&DataType::Bool(true)), "true");
        }

        #[test]
        fn test_search_result_creation() {
            let result = SearchResult {
                file_name: "test.xlsx".to_string(),
                sheet_name: "Sheet1".to_string(),
                row_index: 1,
                row_data: vec!["A".to_string(), "B".to_string()],
                header_row: vec!["Col1".to_string(), "Col2".to_string()],
            };

            assert_eq!(result.file_name, "test.xlsx");
            assert_eq!(result.sheet_name, "Sheet1");
            assert_eq!(result.row_index, 1);
            assert_eq!(result.row_data.len(), 2);
            assert_eq!(result.header_row.len(), 2);
        }
    }
}