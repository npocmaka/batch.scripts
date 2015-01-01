@if (@X)==(@Y) @end /* JSCRIPT COMMENT **


@echo off
cscript //E:JScript //nologo "%~f0"
exit /b

// Sources of wisdom:
//http://social.msdn.microsoft.com/Forums/vstudio/en-US/659030c8-bcf5-4542-bbc6-eaf9679e090a/cannot-create-object-wmi-in-javascript
//http://blogs.technet.com/b/heyscriptingguy/archive/2005/05/23/how-can-i-correlate-logical-drives-and-physical-disks.aspx
//http://stackoverflow.com/a/1144788/388389

************** end of JSCRIPT COMMENT **/


String.prototype.replaceAll = function (find, replace) {
    var str = this;
    return str.replace(new RegExp(find.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'g'), replace);
};


var winmgmts= GetObject("winmgmts:\\\\.\\root\\cimv2")
var drives = winmgmts.ExecQuery( "SELECT * FROM Win32_DiskDrive", null, 48 );
//WScript.Echo(drives);

var drvs = new Enumerator(drives);
for (;!drvs.atEnd();drvs.moveNext()) {
    var drive=drvs.item();

    WScript.Echo( "Physical Disk: " + drive.Caption + " -- " + drive.DeviceID );
    var deviceID = drive.DeviceID.replaceAll( "\\" ,"\\\\");
    var colPartitions = winmgmts.ExecQuery( "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=\"" + 
        deviceID + "\"} WHERE AssocClass =  Win32_DiskDriveToDiskPartition" , null, 48 );

    var colParts = new Enumerator(colPartitions);
    for (;!colParts.atEnd();colParts.moveNext()) {

        var partition=colParts.item();

        //WScript.Echo( "Disk Partition: " + partition.DeviceID );
        var colLogicalDisks = winmgmts.ExecQuery( "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=\"" +
                partition.DeviceID + "\"} WHERE AssocClass = Win32_LogicalDiskToPartition" , null, 48);
        var colLD = new Enumerator(colLogicalDisks);

        if (typeof colLD.item() != "undefined") {
            for (;!colLD.atEnd();colLD.moveNext()) {
                var logicalDisk=colLD.item();
                WScript.Echo( "  Logical Disk: " + logicalDisk.DeviceID + " Disk Partition:  harddisk" + partition.DeviceID.split("#")[1].split(",")[0] + "\\partition" + partition.DeviceID.split("#")[2] );
            }
        } else {
            WScript.Echo( "  Disk Partition: harddisk" + partition.DeviceID.split("#")[1].split(",")[0] + "\\partition" + partition.DeviceID.split("#")[2] );
        }

    }   

}
