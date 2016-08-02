/*

** Author: Tomaz Kastrun
** Created: 02.08.2016; Ljubljana
** Installing R libraries / Packages using T-SQL
** R and T-SQL

*/


USE WideWorldImporters;
GO

--InstallPackage using sp_execute_external_script
EXECUTE sp_execute_external_script    
	   @language = N'R'    
	  ,@script=N'install.packages("ggplot2")'
WITH RESULT SETS (( ResultSet VARCHAR(50)));


-- using Download.file command
EXECUTE sp_execute_external_script    
	   @language = N'R'    
	  ,@script=N'download.file("https://cran.r-project.org/bin/windows/contrib/3.4/ggplot2_2.1.0.zip","ggplot2")
				 install.packages("ggplot2", repos = NULL, type = "source")'
WITH RESULT SETS (( ResultSet VARCHAR(50)));




-- enable xp_cmdshell
EXECUTE SP_CONFIGURE 'xp_cmdshell','1';
GO

RECONFIGURE;
GO



-- deriving from simple procedure
-- Find all Revo libraries
EXECUTE sp_execute_external_script    
	   @language = N'R'    
	  ,@script=N'
				ff <- data.frame(installed.packages())
				ff2<- data.frame(ff$Package[grep("Revo", ff$Package)])
				OutputDataSet<-ff2'
WITH RESULT SETS (( LibraryName VARCHAR(50)));



-- deriving from simple procedure
-- look for libraries with tree
EXECUTE sp_execute_external_script    
	   @language = N'R'    
	  ,@script=N'
				ff <- data.frame(installed.packages())
				ff2<- data.frame(ff$Package[grep("tree", ff$Package)])
				OutputDataSet<-ff2'
WITH RESULT SETS (( LibraryName VARCHAR(50)));

-- (0 row(s) affected)

--Check number of libraries:
EXECUTE sp_execute_external_script
          @language = N'R'
         ,@script = N'installpackages <- nrow(installed.packages());
                    OutputDataSet <- as.data.frame(installpackages);'
         ,@input_data_1 = N'SELECT 1 AS NOF_LIBRARIES'
 WITH RESULT SETS(
                  (NOF_Libraries int)
                  );

-- Number of Libraries: 87


-- Run the XP_CMDSHELL for R package installation
EXEC xp_cmdshell '"C:\Program Files\Microsoft SQL Server\MSSQL13.SQLSERVER2016RC3\R_SERVICES\bin\R.EXE" cmd -e install.packages(''tree'')';  
GO  




-- check again for this library
EXECUTE sp_execute_external_script    
	   @language = N'R'    
	  ,@script=N'
				ff <- data.frame(installed.packages())
				ff2<- data.frame(ff$Package[grep("tree", ff$Package)])
				OutputDataSet<-ff2'
WITH RESULT SETS (( LibraryName VARCHAR(50)));

-- (1 row(s) affected)