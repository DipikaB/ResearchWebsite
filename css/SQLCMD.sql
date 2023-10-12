sqlcmd
1> SELECT * FROM ProdSQL.dbo.SQLShack
2> go


:setvar DB ProdSQL
1> :setvar SRC localhost
1> :setvar TGT localhost\SQLEXPRESS
1> :setvar BACKUP_PATH D:\New folder (3)
Sqlcmd: Error: Syntax error at line 6 near command ':setvar'.
1> :setvar BACKUP_PATH 'D:\New folder (3)'
Sqlcmd: Error: Syntax error at line 7 near command ':setvar'.
1> :setvar BACKUP_PATH D:\PowerSQL
1> :setvar RESTORE_PATH D:\PowerSQL
1> :setvar DATAFILENAME ProdSQL
1> :setvar LOGFILENAME ProdSQL_log
1> :setvar RESTORE_DATA_PATH "D:\PowerSQL"
1> :setvar RESTORE_LOG_PATH "D:\PowerSQL"
1> :setvar COPYPATH D$\PowerSQL
1> :setvar Timeout 100

:CONNECT $(SRC)
Sqlcmd: Successfully connected to server 'localhost'.
1> SELECT @@servername
2> SELECT * FROM sys.databases WHERE name = '$(DB)'
3> go

:CONNECT $(TGT)
Sqlcmd: Successfully connected to server 'localhost\SQLEXPRESS'.
1> SELECT @@servername
2> go

:CONNECT $(SRC)
BACKUP DATABASE $(DB) TO DISK = '$(BACKUP_PATH)\$(DB).bak'
2> WITH COPY_ONLY, NOFORMAT, INIT, NAME = '$(DB) FULL DB Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 5, COMPRESSION
3> GO

print '*** Copy DB $(DB) from SRC server $(SRC) to TGT server $(TGT)***'
2> !!ROBOCOPY $(Backup_path)\ \\$(TGT)\$(COPYPATH) $(DB).*
3> Go

print '**Restore full backup of DB $(DB)***'
2> :CONNECT $(TGT)
Sqlcmd: Successfully connected to server 'localhost\SQLEXPRESS'.
1> go

 USE master
2> Go
Changed database context to 'master'.
1> IF EXISTS (SELECT * FROM sys.databases WHERE name = '$(DB)')
2> begin
3> ALTER DATABASE $(DB) SET SINGLE_USER WITH ROLLBACK IMMEDIATE
4> DROP DATABASE $(DB)
5> END
6> go

 RESTORE DATABASE $(DB)
2> FROM disk = '$(RESTORE_PATH)\$(DB).bak'
3> WITH RECOVERY, NOUNLOAD, STATS = 10, REPLACE,
4> MOVE '$(DATAFILENAME)' TO
5> '$(RESTORE_DATA_PATH)\$(DATAFILENAME).mdf',
6> MOVE '$(LOGFILENAME)' TO
7> '$(RESTORE_DATA_PATH)\$(LOGFILENAME).ldf'
8> go

:CONNECT $(SRC)
Sqlcmd: Successfully connected to server 'localhost'.
1> SELECT @@SERVERNAME
2> SELECT * FROM sys.databases WHERE name = '$(DB)'
3> GO


2> :CONNECT $(TGT)
Sqlcmd: Successfully connected to server 'localhost\SQLEXPRESS'.
1> SELECT @@SERVERNAME
SELECT * FROM sys.databases where name = '$(DB)'
2> GO
























 