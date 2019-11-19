//
//  main.m
//  A main module for starting Python projects under iOS.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <Python.h>
#include <dlfcn.h>


int main(int argc, char *argv[]) {

    NSString *tmp_path;
    NSString *python_home;
    NSString *python_path;
    wchar_t *wpython_home;


    @autoreleasepool {

        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];

        // Special environment to prefer .pyo; also, don't write bytecode
        // because the process will not have write permissions on the device.
        putenv("PYTHONOPTIMIZE=1");
        putenv("PYTHONDONTWRITEBYTECODE=1");
        putenv("PYTHONUNBUFFERED=1");

        // Set the home for the Python interpreter
        python_home = [NSString stringWithFormat:@"%@/Library/Python", resourcePath, nil];
        NSLog(@"PythonHome is: %@", python_home);
        NSFileManager *fileManager = [NSFileManager defaultManager];
 
        if(![fileManager fileExistsAtPath:python_home]){
            NSLog(@"file  not exist");
        }
        wpython_home = Py_DecodeLocale([python_home UTF8String], NULL);
        Py_SetPythonHome(wpython_home);

        // Set the PYTHONPATH
        python_path = [NSString stringWithFormat:@"PYTHONPATH=%@/Library/Application Support/com.hg.demo.demo/app:%@/Library/Application Support/com.hg.demo.demo/app_packages", resourcePath, resourcePath, nil];
        NSLog(@"PYTHONPATH is: %@", python_path);
        putenv((char *)[python_path UTF8String]);

        // iOS provides a specific directory for temp files.
        tmp_path = [NSString stringWithFormat:@"TMP=%@/tmp", resourcePath, nil];
        putenv((char *)[tmp_path UTF8String]);

        NSLog(@"Initializing Python runtime...");
        Py_Initialize();
        PyRun_SimpleString("print('hello world')");//say hello see debug output :)

        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"py"];
        FILE *mainFile = fopen([scriptPath UTF8String], "r");
        PyRun_SimpleFile(mainFile, (char *)[[scriptPath lastPathComponent] UTF8String]) ;
            
    }


    return true;
}

