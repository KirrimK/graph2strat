let version = (match Build_info.V1.version() with
                  None -> "unknown"
                | Some v -> Build_info.V1.Version.to_string v);;
