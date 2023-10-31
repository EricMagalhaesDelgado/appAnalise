function anateldb_Read(RootFolder)

    global AnatelDB
    global AnatelDB_info
    
    if isempty(AnatelDB) || isempty(AnatelDB_info)
        filename_mat = fullfile(RootFolder, 'DataBase', 'Anatel.mat');

        if isfile(filename_mat)
            load(filename_mat, 'AnatelDB', 'AnatelDB_info', '-mat')
        
        else
            filename_parquet = fullfile(RootFolder, 'Temp', 'AnatelDB.parquet.gzip');

            try
                AnatelDB      = parquetread(filename_parquet);
                
                FileVersion   = webread(Misc_PublicLinks(RootFolder));
                AnatelDB_info = FileVersion.anateldb;
                                
                save(filename_mat, 'AnatelDB', 'AnatelDB_info')
            
            catch ME
                filename_mat_old = fullfile(RootFolder, 'DataBase', 'Anatel_old.mat');

                if isfile(filename_mat_old)
                    load(filename_mat_old, 'AnatelDB', 'AnatelDB_info', '-mat')
                    error('A base do anateldb não foi atualizada pelas razões expostas a seguir, sendo usada a base antiga armazenada no arquivo "Anatel_old.mat".\n\n%s', getReport(ME))
                else
                    error('A base do anateldb não foi localizada.')
                end
            end
        end
    end

end