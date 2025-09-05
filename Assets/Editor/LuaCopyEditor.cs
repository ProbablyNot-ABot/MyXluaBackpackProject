using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class LuaCopyEditor : Editor
{
    [MenuItem("XLua/自动生成txt后缀的Lua")]
    public static void CopyLuaToTxt()
    {
        //首先要找到我们的 所有Lua文件
        string path = Application.dataPath + "/Lua/";
        //判断路径是否存在
        if(!Directory.Exists(path))
        {
            Debug.LogError("Lua文件夹不存在，请检查路径：" + path);
            return;
        }
        //得到每一个lua文件的路径 才能进行迁移拷贝 后缀名为.lua的
        string[] strs = Directory.GetFiles(path,"*.lua");

        //然后把Lua文件复制到一个新的文件夹中
        //首先定一个新的文件夹路径
        string newPath = Application.dataPath + "/LuaTxt/";

        //为了避免一些被删除的lua文件 不再使用 我们应该先清空目标文件夹路径

        //判断新的路径文件夹是否存在
        if (!Directory.Exists(newPath))
            Directory.CreateDirectory(newPath);
        else
        {
            //得到该路径中所有.txt的文件 把他们全部删除
            string[] oldFiles = Directory.GetFiles(newPath, "*.txt");
            for (int i = 0; i < oldFiles.Length; i++)
            {
                //删除文件
                File.Delete(oldFiles[i]);
            }
        }

        List<string> newFileNames = new List<string>();
        string fileName;
        for (int i = 0; i < strs.Length; i++)
        {
            fileName = newPath + strs[i].Substring(strs[i].LastIndexOf("/") + 1) + ".txt";
            newFileNames.Add(fileName);
            File.Copy(strs[i], fileName);
        }

        AssetDatabase.Refresh();

        //刷新过后再来改指定位置 因为 如果不刷新 第一次改会没用
        for (int i = 0; i < newFileNames.Count; i++)
        {
            //Unity API
            //该API传入的路径必须是 相对Assets文件夹的 Assets/..../....
            AssetImporter importer = AssetImporter.GetAtPath(newFileNames[i].Substring(newFileNames[i].IndexOf("Assets")));
            if(importer != null)
            {
                importer.assetBundleName = "lua";
            }
        }
    }
}
