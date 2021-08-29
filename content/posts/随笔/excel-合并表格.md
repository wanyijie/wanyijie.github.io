1. 前提： 要合并的表格表格列数相同
2. 在要合并的表格放一个文件内，建一个新的空表格：
![image.png](https://upload-images.jianshu.io/upload_images/6000429-d52aac8db46c333c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.打开表格：

4.鼠标放到左下角的sheet导航栏上右键选择查看源码：
![image.png](https://upload-images.jianshu.io/upload_images/6000429-c2be23288bf3f69a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5. 把后面的代码贴入文本框中点顶部菜单栏的运行即可：
![image.png](https://upload-images.jianshu.io/upload_images/6000429-4a3266b7c437cb4c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

6. 脚本
```
Sub 合并当前目录下所有工作簿的全部工作表()
Dim MyPath, MyName, AWbName
Dim Wb As Workbook, WbN As String
Dim G As Long
Dim Num As Long
Dim BOX As String
Application.ScreenUpdating = False
MyPath = ActiveWorkbook.Path
MyName = Dir(MyPath & "\" & "*.xlsx")
AWbName = ActiveWorkbook.Name
Num = 0
Do While MyName <> ""
If MyName <> AWbName Then
Set Wb = Workbooks.Open(MyPath & "\" & MyName)
Num = Num + 1
With Workbooks(1).ActiveSheet
.Cells(.Range("B1048576").End(xlUp).Row + 2, 1) = Left(MyName, Len(MyName) - 4)
For G = 1 To Sheets.Count
Wb.Sheets(G).UsedRange.Copy .Cells(.Range("B1048576").End(xlUp).Row + 1, 1)
Next
WbN = WbN & Chr(13) & Wb.Name
Wb.Close False
End With
End If
MyName = Dir
Loop
Range("B1").Select
Application.ScreenUpdating = True
MsgBox "共合并了" & Num & "个工作薄下的全部工作表。如下：" & Chr(13) & WbN, vbInformation, "提示"
End Sub
```
