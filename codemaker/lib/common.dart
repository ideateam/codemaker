
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/basic.dart';
import 'package:highlight/languages/cmake.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/delphi.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/json.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/lua.dart';
import 'package:highlight/languages/objectivec.dart';
import 'package:highlight/languages/perl.dart';
import 'package:highlight/languages/php.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/shell.dart';
import 'package:highlight/languages/sqf.dart';
import 'package:highlight/languages/sql.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/tex.dart';
import 'package:highlight/languages/vue.dart';
import 'package:highlight/languages/xml.dart';
import 'package:highlight/languages/yaml.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

//定义回调
typedef MyCallBack = Function(String type,String val1,String val2);
typedef MyThemeCallBack = Function(String type);

//回调监听
class MyCallBackListener {
  final MyCallBack myCallBack;

  MyCallBackListener({required this.myCallBack});
}

//回调监听
class MyThemeCallBackListener {
  final MyThemeCallBack myCallBack;

  MyThemeCallBackListener({required this.myCallBack});
}

class Common {
  factory Common() => _getInstance();

  static Common get instance => _getInstance();
  static Common _instance = Common._internal(); // 单例对象

  static Common _getInstance() {
    _instance ??= Common._internal();
    return _instance;
  }

  Common._internal();

  /////////////////////////////////////////////////////////////

  String rootPath = ''; // 根路径

  String colorThemeState = "";

  List languageTitleList = [
    "C",
    "C#",
    "C++",
    "PHP",
    "Swift",
    "Objective\nC",
    "HTML",
    "Python",
    "Perl",
    "Go",
    "R",
    "Kotlin",
    "Java",
    "Java\nScript",
    "Visual\nBasic",
    "Bash",
    "SQL",
    "Ruby",
    "Rust",
    "TypeScript",
    "Power\nShell",
    "Delphi",
    "Assembly",
    "Flutter",
    "Erlang",
  ];

  Widget languageTitleWidgetList(String currentSelectSettingTitle){

    TextStyle dStyle = const TextStyle(fontSize: 12,color: Colors.white);

    switch (currentSelectSettingTitle) {
      case "C":
        return  Container(
            padding: const EdgeInsets.all(5),
            child: Text("C语言是一门面向过程的、抽象化的通用程序设计语言，广泛应用于底层开发。\n\nC语言能以简易的方式编译、处理低级存储器。C语言是仅产生少量的机器语言以及不需要任何运行环境支持便能运行的高效率程序设计语言。\n\n尽管C语言提供了许多低级处理的功能，但仍然保持着跨平台的特性，以一个标准规格写出的C语言程序可在包括类似嵌入式处理器以及超级计算机等作业平台的许多计算机平台上进行编译",style: dStyle,)
        );
      case "C#":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("C#是微软公司发布的一种由C和C++衍生出来的面向对象的编程语言、运行于.NET Framework和.NET Core(完全开源，跨平台)之上的高级程序设计语言。并定于在微软职业开发者论坛(PDC)上登台亮相。\n\nC#是微软公司研究员Anders Hejlsberg的最新成果。\n\nC#看起来与Java有着惊人的相似；它包括了诸如单一继承、接口、与Java几乎同样的语法和编译成中间代码再运行的过程。\n\n但是C#与Java有着明显的不同，它借鉴了Delphi的一个特点，与COM（组件对象模型）是直接集成的，而且它是微软公司 .NET windows网络框架的主角。",style: dStyle,),
        );
      case "C++":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("C++（c plus plus）是一种计算机高级程序设计语言，由C语言扩展升级而产生，最早于1979年由本贾尼·斯特劳斯特卢普在AT&T贝尔工作室研发。 \n\nC++既可以进行C语言的过程化程序设计，又可以进行以抽象数据类型为特点的基于对象的程序设计，还可以进行以继承和多态为特点的面向对象的程序设计。C++擅长面向对象程序设计的同时，还可以进行基于过程的程序设计。\n\nC++几乎可以创建任何类型的程序：游戏、设备驱动程序、HPC、云、桌面、嵌入式和移动应用等。 甚至用于其他编程语言的库和编译器也使用C++编写。",style: dStyle,),
        );
      case "PHP":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("PHP（PHP: Hypertext Preprocessor）即“超文本预处理器”，是在服务器端执行的脚本语言，尤其适用于Web开发并可嵌入HTML中。\n\nPHP语法学习了C语言，吸纳Java和Perl多个语言的特色发展出自己的特色语法，并根据它们的长项持续改进提升自己，例如java的面向对象编程，该语言当初创建的主要目标是让开发人员快速编写出优质的web网站。\n\n PHP同时支持面向对象和面向过程的开发，使用上非常灵活",style: dStyle,),
        );
      case "Swift":
        return  Container(
            padding: const EdgeInsets.all(5),
            child: Text("Swift，苹果于2014年WWDC苹果开发者大会发布的新开发语言，可与Objective-C共同运行于macOS和iOS平台，用于搭建基于苹果平台的应用程序。\n\nSwift是一款易学易用的编程语言，而且它还是第一套具有与脚本语言同样的表现力和趣味性的系统编程语言。\n\nSwift的设计以安全为出发点，以避免各种常见的编程错误类别。 2015年12月4日，苹果公司宣布其Swift编程语言开放源代码。长600多页的The Swift Programming Language 可以在线免费下载。",style: dStyle,)
        );
      case "Objective\nC":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Objective-C，通常写作ObjC或OC和较少用的Objective C或Obj-C，是扩充C的面向对象编程语言。\n\n它主要使用于Mac OS X和GNUstep这两个使用OpenStep标准的系统，而在NeXTSTEP和OpenStep中它更是基本语言。Objective-C是非常实用的语言。\n\n它是一个用C写成很小的运行库，令应用程序的尺寸增加很小，和大部分OO系统使用极大的VM执行时间会取代了整个系统的运作相反。Objective-C写成的程序通常不会比其原始码大很多。而其函式库(通常没附在软件发行本)亦和Smalltalk系统要使用极大的内存来开启一个窗口的情况相反。\n\n因此，Objective-C它完全兼容标准C语言（C++对C语言的兼容仅在于大部分语法上，而在ABI（Application Binary Interface）上，还需要使用extern 'C'这种显式声明来与C函数进行兼容，而在此基础上增加了面向对象编程语言的特性以及Smalltalk消息机制。",style: dStyle,),
        );
      case "HTML":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("HTML的全称为超文本标记语言，是一种标记语言。它包括一系列标签，通过这些标签可以将网络上的文档格式统一，使分散的Internet资源连接为一个逻辑整体。HTML文本是由HTML命令组成的描述性文本，HTML命令可以说明文字，图形、动画、声音、表格、链接等。 超文本是一种组织信息的方式，它通过超级链接方法将文本中的文字、图表与其他信息媒体相关联。\n\n这些相互关联的信息媒体可能在同一文本中，也可能是其他文件，或是地理位置相距遥远的某台计算机上的文件。这种组织信息方式将分布在不同位置的信息资源用随机方式进行连接，为人们查找，检索信息提供方便。",style: dStyle,),
        );
      case "Python":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Python由荷兰国家数学与计算机科学研究中心的吉多·范罗苏姆于1990年代初设计，作为一门叫作ABC语言的替代品。\n\nPython提供了高效的高级数据结构，还能简单有效地面向对象编程。Python语法和动态类型，以及解释型语言的本质，使它成为多数平台上写脚本和快速开发应用的编程语言，随着版本的不断更新和语言新功能的添加，逐渐被用于独立的、大型项目的开发。\n\nPython在各个编程语言中比较适合新手学习，Python解释器易于扩展，可以使用C、C++或其他可以通过C调用的语言扩展新的功能和数据类型。 \n\nPython也可用于可定制化软件中的扩展程序语言。Python丰富的标准库，提供了适用于各个主要系统平台的源码或机器码。",style: dStyle,),
        );
      case "Perl":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Perl一种功能丰富的计算机程序语言，运行在超过100种计算机平台上，适用广泛，从最初是为文本处理而开发的，现在用于各种任务，包括系统管理，Web开发，网络编程，GUI开发等。\n\nPerl易于使用、高效、完整，而不失美观（小巧，优雅，简约）。同时支持过程和面向对象编程，对文本处理具有强大的内置支持，并且拥有第三方模块集合之一。 Perl借取了C、sed、awk、shell脚本语言以及很多其他程序语言的特性，其中最重要的特性是它内部集成了正则表达式的功能，以及巨大的第三方代码库CPAN。",style: dStyle,),
        );
      case "Go":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Go（又称Golang）是Google开发的一种静态强类型、编译型、并发型，并具有垃圾回收功能的编程语言。\n\n罗伯特·格瑞史莫（Robert Griesemer），罗布·派克（Rob Pike）及肯·汤普逊（Ken Thompson）于2007年9月开始设计Go，稍后Ian Lance Taylor、Russ Cox加入项目。Go是基于Inferno操作系统所开发的。Go于2009年11月正式宣布推出，成为开放源代码项目，并在Linux及Mac OS X平台上进行了实现，后来追加了Windows系统下的实现。在2016年，Go被软件评价公司TIOBE 选为“TIOBE 2016 年最佳语言”。 目前，Go每半年发布一个二级版本（即从a.x升级到a.y）",style: dStyle,),
        );
      case "R":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("R是统计领域广泛使用的诞生于1980年左右的S语言的一个分支。\n\n可以认为R是S语言的一种实现。而S语言是由AT&T贝尔实验室开发的一种用来进行数据探索、统计分析和作图的解释型语言。最初S语言的实现版本主要是S-PLUS。S-PLUS是一个商业软件，它基于S语言，并由MathSoft公司的统计科学部进一步完善。\n\n后来新西兰奥克兰大学的Robert Gentleman和Ross Ihaka及其他志愿人员开发了一个R系统。由“R开发核心团队”负责开发。R可以看作贝尔实验室（AT&T BellLaboratories）的Rick Becker、John Chambers和Allan Wilks开发的S语言的一种实现。\n\n当然，S语言也是S-Plus的基础。所以，两者在程序语法上可以说是几乎一样的，可能只是在函数方面有细微差别，程序十分容易地就能移植到一程序中，而很多一的程序只要稍加修改也能运用于R。",style: dStyle,),
        );
      case "Kotlin":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Kotlin（科特林）是一个用于现代多平台应用的静态编程语言 ，由 JetBrains 开发。\n\nKotlin可以编译成Java字节码，也可以编译成JavaScript，方便在没有JVM的设备上运行。除此之外Kotlin还可以编译成二进制代码直接运行在机器上（例如嵌入式设备或 iOS）。 \n\nKotlin已正式成为Android官方支持开发语言。\n\n2011年7月，JetBrains推出Kotlin项目，这是一个面向JVM的新语言，它已被开发一年之久。JetBrains负责人Dmitry Jemerov说，大多数语言没有他们正在寻找的特性，Scala除外。但是，他指出了Scala的编译时间慢这一明显缺陷。Kotlin的既定目标之一是像Java一样快速编译。 2012年2月，JetBrains以Apache 2许可证开源此项目。 Jetbrains希望这个新语言能够推动IntelliJ IDEA的销售。 Kotlin v1.0于2016年2月15日发布。这被认为是第一个官方稳定版本，并且JetBrains已准备从该版本开始的长期向后兼容性。 在Google I/O 2017中，Google宣布在Android上为Kotlin提供一等支持。",style: dStyle,),
        );
      case "Java":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Java是一门面向对象的编程语言，不仅吸收了C++语言的各种优点，还摒弃了C++里难以理解的多继承、指针等概念，因此Java语言具有功能强大和简单易用两个特征。Java语言作为静态面向对象编程语言的代表，极好地实现了面向对象理论，允许程序员以优雅的思维方式进行复杂的编程 。\n\nJava具有简单性、面向对象、分布式、健壮性、安全性、平台独立与可移植性、多线程、动态性等特点 。Java可以编写桌面应用程序、Web应用程序、分布式系统和嵌入式系统应用程序等 。",style: dStyle,),
        );
      case "Java\nScript":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("JavaScript（简称“JS”）是一种具有函数优先的轻量级，解释型或即时编译型的编程语言。虽然它是作为开发Web页面的脚本语言而出名，但是它也被用到了很多非浏览器环境中，JavaScript基于原型编程、多范式的动态脚本语言，并且支持面向对象、命令式、声明式、函数式编程范式。 \n\nJavaScript在1995年由Netscape公司的Brendan Eich，在网景导航者浏览器上首次设计实现而成。因为Netscape与Sun合作，Netscape管理层希望它外观看起来像Java，因此取名为JavaScript。但实际上它的语法风格与Self及Scheme较为接近。\n\nJavaScript的标准是ECMAScript。截至2012年，所有浏览器都完整的支持ECMAScript 5.1，旧版本的浏览器至少支持ECMAScript 3标准。2015年6月17日，ECMA国际组织发布了ECMAScript的第六版，该版本正式名称为ECMAScript 2015，但通常被称为ECMAScript 6或者ES2015。",style: dStyle,),
        );
      case "Visual\nBasic":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Visual Basic（简称VB）是Microsoft开发的一种面向对象的编程语言。\n\n使用 Visual Basic即可快速、轻松地创建类型安全的.NET应用。 'Visual'指的是开发图形用户界面 (GUI) 的方法——不需编写大量代码去描述界面元素的外观和位置，而只要把预先建立的对象add到屏幕上的一点即可。\n\n'Basic'指的是 BASIC (Beginners All-Purpose Symbolic Instruction Code) 语言，是一种在计算技术发展历史上应用得最为广泛的语言。Visual Basic源自于BASIC编程语言。\n\nVB拥有图形用户界面（GUI）和快速应用程序开发（RAD）系统，可以轻易的使用DAO、RDO、ADO连接数据库，或者轻松的创建Active X控件，用于高效生成类型安全和面向对象的应用程序。程序员可以轻松的使用VB提供的组件快速建立一个应用程序。",style: dStyle,),
        );
      case "Bash":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Bash，Unix shell的一种，在1987年由布莱恩·福克斯为了GNU计划而编写。\n\n1989年发布第一个正式版本，原先是计划用在GNU操作系统上，但能运行于大多数类Unix系统的操作系统之上，包括Linux与Mac OS X v10.4都将它作为默认shell。\n\nBash是Bourne shell的后继兼容版本与开放源代码版本，它的名称来自Bourne shell（sh）的一个双关语（Bourne again / born again）：Bourne-Again SHell。\n\nBash是一个命令处理器，通常运行于文本窗口中，并能执行用户直接输入的命令。Bash还能从文件中读取命令，这样的文件称为脚本。和其他Unix shell 一样，它支持文件名替换（通配符匹配）、管道、here文档、命令替换、变量，以及条件判断和循环遍历的结构控制语句。包括关键字、语法在内的基本特性全部是从sh借鉴过来的。其他特性，例如历史命令，是从csh和ksh借鉴而来。总的来说，Bash虽然是一个满足POSIX规范的shell，但有很多扩展。\n\n一个名为Shellshock的安全漏洞在2014年9月初被发现，并迅速导致互联网上的一系列攻击。这个漏洞可追溯到1989年发布的1.03版本。",style: dStyle,),
        );
      case "SQL":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("结构化查询语言（Structured Query Language）简称SQL，是一种特殊目的的编程语言，是一种数据库查询和程序设计语言，用于存取数据以及查询、更新和管理关系数据库系统。\n\n结构化查询语言是高级的非过程化编程语言，允许用户在高层数据结构上工作。它不要求用户指定对数据的存放方法，也不需要用户了解具体的数据存放方式，所以具有完全不同底层结构的不同数据库系统, 可以使用相同的结构化查询语言作为数据输入与管理的接口。结构化查询语言语句可以嵌套，这使它具有极大的灵活性和强大的功能。",style: dStyle,),
        );
      case "Ruby":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Ruby，一种简单快捷的面向对象（面向对象程序设计）脚本语言。\n\n在20世纪90年代由日本人松本行弘(Yukihiro Matsumoto)开发，遵守GPL协议和Ruby License。它的灵感与特性来自于 Perl、Smalltalk、Eiffel、Ada以及 Lisp 语言。由 Ruby 语言本身还发展出了JRuby（Java平台）、IronRuby（.NET平台）等其他平台的 Ruby 语言替代品。",style: dStyle,),
        );
      case "Rust":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Rust是一门系统编程语言，专注于安全，尤其是并发安全，支持函数式和命令式以及泛型等编程范式的多范式语言。\n\nRust在语法上和C++类似，设计者想要在保证性能的同时提供更好的内存安全。 Rust最初是由Mozilla研究院的Graydon Hoare设计创造，然后在Dave Herman, Brendan Eich以及很多其他人的贡献下逐步完善的。Rust的设计者们通过在研发Servo网站浏览器布局引擎过程中积累的经验优化了Rust语言和Rust编译器。 \n\nRust编译器是在MIT License 和 Apache License 2.0双重协议声明下的免费开源软件。 Rust已经连续七年（2016，2017，2018，2019，2020, 2021, 2022）在Stack Overflow开发者调查的“最受喜爱编程语言”评选项目中折取桂冠。",style: dStyle,),
        );
      case "TypeScript":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("TypeScript是微软开发的一个开源的编程语言，通过在JavaScript的基础上添加静态类型定义构建而成。\n\nTypeScript通过TypeScript编译器或Babel转译为JavaScript代码，可运行在任何浏览器，任何操作系统。\n\nTypeScript添加了很多尚未正式发布的ECMAScript新特性（如装饰器）。2012年10月，微软发布了首个公开版本的TypeScript，2013年6月19日，在经历了一个预览版之后微软正式发布了正式版TypeScript。当前最新正式版本为TypeScript 5.2, 2023年8月发布。",style: dStyle,),
        );
      case "Power\nShell":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Windows PowerShell 是微软发布的一种命令行外壳程序和脚本环境，使命令行用户和脚本编写者可以利用 .NET Framework的强大功能。\n\n它引入了许多非常有用的新概念，从而进一步扩展了您在 Windows 命令提示符和 Windows Script Host 环境中获得的知识和创建的脚本。\n\nWindows PowerShell v3将伴随着Microsoft Hyper-V 3.0和Windows Server 2012发布。PowerShell v3是一个Windows任务自动化的框架，它由一个命令行shell和内置在这个.NET框架上的编程语言组成。\n\nPowerShell v3采用新的cmdlet让管理员能够更深入到系统进程中，这些进程可以制作成可执行的文件或脚本（script）。一条cmdlet是一条轻量命令，Windows PowerShell运行时间在自动化脚本的环境里调用它。\n\nCmdlet包括显示当前目录的Get-Location，访问文件内容的Get-Content和结束运行进程的Stop-Process。\n\nPowerShell v3在Windows Server 8中装载了Windows Management Framework 3.0。PowerShell运行环境也能嵌入到其它应用。",style: dStyle,),
        );
      case "Delphi":
        return  Container(
          padding: const EdgeInsets.all(5),
          child: Text("Delphi，是Windows平台下著名的快速应用程序开发工具(Rapid Application Development，简称RAD)。\n\n它的前身，即是DOS时代盛行一时的“BorlandTurbo Pascal”，最早的版本由美国Borland（宝兰）公司于1995年开发。主创者为Anders Hejlsberg。经过数年的发展，此产品也转移至Embarcadero公司旗下。Delphi是一个集成开发环境（IDE），使用的核心是由传统Pascal语言发展而来的Object Pascal，以图形用户界面为开发环境，透过IDE、VCL工具与编译器，配合连结数据库的功能，构成一个以面向对象程序设计为中心的应用程序开发工具。\n\n由Borland公司推出的Delphi是全新的可视化编程环境，为我们提供了一种方便、快捷的Windows应用程序开发工具。它使用了MicrosoftWindows图形用户界面的许多先进特性和设计思想，采用了弹性可重复利用的完整的面向对象程序语言(Object-Oriented Language）、当今世界上最快的编译器、最为领先的数据库技术。对于广大的程序开发人员来讲，使用Delphi开发应用软件，无疑会大大地提高编程效率，而且随着应用的深入，您将会发现编程不再是枯燥无味的工作——Delphi的每一个设计细节，都将带给您一份欣喜。",style: dStyle,),
        );
      case "Assembly":
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text("第二代编程语言(2GL)指的是组合语言(Assembly Language)，是最接近机器语言(1GL)的编程语言。它是一种符号式语言，以简单易懂的英文或数字符来取代机器语言中的二进码，也称之为助忆语言(Mnemonic Language)。组合语言无法直接供给机器使用，仍须透过组合程式(Assembler)翻译成由‘0’、‘1’组成的机器语言，才能被机器加以执行。\n\n组合语言近似于机器语言，一样不具移植性，所以跟机器语言一样被称为低阶语言。",style: dStyle,),
        );
      case "Flutter":
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text("Flutter是Google开源的构建用户界面（UI）工具包，帮助开发者通过一套代码库高效构建多平台精美应用，支持移动、Web、桌面和嵌入式平台。 [5]Flutter 开源、免费，拥有宽松的开源协议，适合商业项目。\n\nFlutter可以方便的加入现有的工程中。在全世界，Flutter 正在被越来越多的开发者和组织使用，并且 Flutter是完全免费、开源的。它也是构建未来的 Google Fuchsia 应用的主要方式。\n\nFlutter组件采用现代响应式框架构建，这是从React中获得的灵感，中心思想是用组件(widget)构建你的UI。 组件描述了在给定其当前配置和状态时他们显示的样子。当组件状态改变，组件会重构它的描述(description)，Flutter 会对比之前的描述， 以确定底层渲染树从当前状态转换到下一个状态所需要的最小更改。",style: dStyle,),
        );
      case "Erlang":
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text("Erlang在1991年由爱立信公司向用户推出了第一个版本，经过不断的改进完善和发展，在1996年爱立信又为所有的Erlang用户提供了一个非常实用且稳定的OTP软件库并在1998年发布了第一个开源版本。Erlang同时支持的操作系统有linux,windows,unix等，可以说适用于主流的操作系统上，尤其是它支持多核的特性非常适合多核CPU，而分布式特性也可以很好融合各种分布式集群。\n\nErlang是一种通用的面向并发的编程语言，它由瑞典电信设备制造商爱立信所辖的CS-Lab开发，目的是创造一种可以应对大规模并发活动的编程语言和运行环境。Erlang问世于1987年，经过十年的发展，于1998年发布开源版本。Erlang是运行于虚拟机的解释性语言，但是也包含有乌普萨拉大学高性能Erlang计划（HiPE）开发的本地代码编译器，自R11B-4版本开始，Erlang也开始支持脚本式解释器。在编程范型上，Erlang属于多重范型编程语言，涵盖函数式、并发式及分布式。顺序执行的Erlang是一个及早求值,单次赋值和动态类型的函数式编程语言。",style: dStyle,),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text("",style: dStyle,),
        );
    }
  }

  List<String> allcreateFileSuffixTypeTitle = [
    ".html",
    ".php",
    ".asp",
    ".py",
    ".go",
    ".kt",
    ".lua",
    ".text",
    ".sh",
    ".cs",
    ".sql",
    ".vue",
    ".dart",
    ".rb",
    ".rs",
    ".h",
    ".m",
    ".mm",
    ".java",
    ".json",
    ".wps",
    ".doc",
    ".rtf",
    ".xls",
    ".xlsx",
    ".swift",
    ".sqf",
    ".pl",
    ".dpr",
    ".vb",
    ".xml",
    ".plist"
  ];

  List<String> settingTitleList = [
    "关于我们",
    "主题颜色",
    "帮助中心",
    "意见反馈",
    "其他",
  ];

  //系统颜色变更的颜色变化
  Color systemModeColorChangeState(BuildContext context,Color whiteThemeColor,Color darkColor ){

    if(colorThemeState == "1"){
      //暗黑色
      return darkColor;
    }else if(colorThemeState == "2"){
      //浅色
      return whiteThemeColor;
    }else {
      //跟随系统
      return ui.PlatformDispatcher.instance.platformBrightness == Brightness.light ? whiteThemeColor : darkColor;
      // return MediaQuery.of(context).platformBrightness == Brightness.light ? whiteThemeColor : darkColor;
    }
  }

  Widget settingWidgetList(String currentSelectSettingTitle,BuildContext context,String colorState,{required MyThemeCallBackListener callBackListener}){

    switch (currentSelectSettingTitle) {
      case "关于我们":
        return  Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            // color: systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),
            alignment: Alignment.center,
            child: Stack(
              children: [
                Column(
                  children: [
                    const Spacer(),
                    Container(
                      // color: Colors.red,
                      margin:
                      const EdgeInsets.only(left: 5, right: 5),
                      width: 120,
                      height: 120,
                      child: Image.asset("images/1024x1024icon.png"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text:  TextSpan(
                          text: "CODE MAKER",
                          style: TextStyle(color:systemModeColorChangeState(context,Colors.black,Colors.white70),fontSize: 50,fontWeight: FontWeight.bold),
                          children: [
                            const TextSpan(text:"\n"),
                            TextSpan(
                              text: " 2024" ,
                              style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white70),fontSize: 18,fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "      版本  v1.0.1\n\n" ,
                              style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white38),fontSize: 12,fontWeight: FontWeight.normal),
                            ),
                            const TextSpan(
                              text: "  GitHub  " ,
                              style: TextStyle(backgroundColor: Colors.blueAccent,color: Colors.white70,fontSize: 10,fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "  https://github.com/ideateam/codemaker\n" ,
                              style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white38),fontSize: 12,fontWeight: FontWeight.normal),
                            ),
                            // TextSpan(
                            //   text: "  Gitee     " ,
                            //   style: TextStyle(backgroundColor: Colors.blueAccent,color: Colors.white70,fontSize: 10,fontWeight: FontWeight.normal),
                            // ),
                            // TextSpan(
                            //   text: "  https://pub.dev/packages/url_launcher" ,
                            //   style: TextStyle(color: Colors.white38,fontSize: 12,fontWeight: FontWeight.normal),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   // color: Colors.red,
                    //   margin:
                    //   const EdgeInsets.only(left: 5, right: 5),
                    //   // width: 120,
                    //   height: 120,
                    //   child: TextField(
                    //     controller: TextEditingController(text: "https://pub.dev/packages/url_launcher"),
                    //   ),
                    // ),
                    const Spacer()
                  ],
                ),
              ],
            )
        );
      case "主题颜色":
        return  Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          // color: systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12,bottom: 12),
                    child: const Row(
                      children: [
                        Text("     主题样式一 :",style: TextStyle(color: Colors.white,fontSize: 10),),
                        Spacer()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 118,
                        height: 40,
                        // color: Colors.black54,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0,0.5],
                              colors: [Colors.white,Colors.black]),
                        ),
                        alignment: Alignment.center,
                        child: TextButton(onPressed: (){

                          print("----0------跟随系统-----------------");
                          colorThemeState = "";
                          callBackListener.myCallBack("0");
                        }, child: Row(
                          children: [
                            const Spacer(),
                            const Text("跟随系统",style: TextStyle(color: Colors.white,fontSize: 11)),
                            const Spacer(),
                            Icon(Icons.check_circle,color: colorState == "" ? Colors.green : Colors.white ,size: 15,),
                            const Spacer(),
                          ],
                        )),
                      ),
                      const Spacer(),
                      Container(
                        width: 118,
                        height: 40,
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: TextButton(onPressed: (){
                          print("----1------暗黑色-----------------");
                          colorThemeState = "1";
                          callBackListener.myCallBack("1");
                        }, child: Row(
                          children: [
                            const Spacer(),
                            const Text("暗黑色",style: TextStyle(color: Colors.white,fontSize: 11)),
                            const Spacer(),
                            Icon(Icons.check_circle,color: colorState == "1" ? Colors.green : Colors.white,size: 15,),
                            const Spacer(),
                          ],
                        )),
                      ),
                      const Spacer(),
                      Container(
                        width: 118,
                        height: 40,
                        color: Colors.white54,
                        alignment: Alignment.center,
                        child: TextButton(onPressed: (){

                          colorThemeState = "2";

                          print("----2------浅色-----------------");
                          callBackListener.myCallBack("2");
                        }, child:  Row(
                          children: [
                            const Spacer(),
                            const Text("浅色",style: TextStyle(color: Colors.black,fontSize: 11)),
                            const Spacer(),
                            Icon(Icons.check_circle,color: colorState == "2" ? Colors.green : Colors.white,size: 15,),
                            const Spacer(),
                          ],
                        )),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 18,bottom: 12),
                    child: const Row(
                      children: [
                        Text("     主题样式二 :",style: TextStyle(color: Colors.white,fontSize: 10)),
                        Spacer()
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.white70,
                            child: const Text("1"),
                          ),
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.red,
                            child: const Text("2"),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0,right: 0),
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.white70,
                            child: const Text("1"),
                          ),
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.red,
                            child: const Text("2"),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0,right: 0),
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.white70,
                            child: const Text("1"),
                          ),
                          const Spacer(),
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.red,
                            child: const Text("2"),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 0,right: 0),
                        height: 20,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      case "帮助中心":
        return  Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          // color: systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),
          alignment: Alignment.center,
          child: const Text(""),
        );
      case "意见反馈":
        return  Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          // color: systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12,bottom: 12),
                    child: const Row(
                      children: [
                        Text("     反馈方式 一 :",style: TextStyle(color: Colors.white,fontSize: 10),),
                        Spacer()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 450,
                        height: 40,
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: const Text("暗黑色",style: TextStyle(color: Colors.white,fontSize: 10)),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 18,bottom: 12),
                    child: const Row(
                      children: [
                        Text("     反馈方式 二 :",style: TextStyle(color: Colors.white,fontSize: 10)),
                        Spacer()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 450,
                        height: 200,
                        color: Colors.black54,
                        alignment: Alignment.center,
                        child: TextField(controller: TextEditingController(text: ""),maxLines: 20,),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 55,top: 12),
                    alignment: Alignment.topRight,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white54),),
                      onPressed: () {

                      },
                      child: const Text(
                        "提交反馈内容",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      default:
        return  Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          // color: systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),
          alignment: Alignment.center,
          child: const Text(""),
        );
    }
  }
  String getFileSize(int fileSize) {
    String str = '';

    if (fileSize < 1024) {
      str = '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      str = '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      str = '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }

    return str;
  }

  String selectIcon(String ext) {
    String iconImg = 'images/unknown.png';

    switch (ext) {
      case '.ppt':
      case '.pptx':
        iconImg = 'images/ppt.png';
        break;
      case '.doc':
      case '.docx':
        iconImg = 'images/word.png';
        break;
      case '.xls':
      case '.xlsx':
        iconImg = 'images/excel.png';
        break;
      case '.jpg':
      case '.jpeg':
      case '.png':
        iconImg = 'images/image.png';
        break;
      case '.txt':
        iconImg = 'images/txt.png';
        break;
      case '.mp3':
        iconImg = 'images/mp3.png';
        break;
      case '.mp4':
        iconImg = 'images/video.png';
        break;
      case '.rar':
      case '.zip':
        iconImg = 'images/zip.png';
        break;
      case '.psd':
        iconImg = 'images/psd.png';
        break;
      default:
        iconImg = 'images/file.png';
        break;
    }
    return iconImg;
  }

  bool isImageBool(String endStr){

    String iconImg = '';

    String finalStr = endStr;
    bool isImageBool = true;
    if(finalStr.toLowerCase().endsWith(".png")){
      iconImg = "png";
    }else if(finalStr.endsWith(".jpg")){
      iconImg = "jpg";
    }else if(finalStr.endsWith(".jpeg")){
      iconImg = "jpeg";
    }else if(finalStr.endsWith(".gif")){
      iconImg = "gif";
    }else if(finalStr.endsWith(".webp")){
      iconImg = "webp";
    }else if(finalStr.endsWith(".bmp")){
      iconImg = "bmp";
    }else if(finalStr.endsWith(".tif")){
      iconImg = "tif";
    }else if(finalStr.endsWith(".pcx")){
      iconImg = "pcx";
    }else if(finalStr.endsWith(".tga")){
      iconImg = "tga";
    }else if(finalStr.endsWith(".exif")){
      iconImg = "exif";
    }else if(finalStr.endsWith(".fpx")){
      iconImg = "fpx";
    }else if(finalStr.endsWith(".cdr")){
      iconImg = "cdr";
    }else if(finalStr.endsWith(".dxf")){
      iconImg = "dxf";
    }else if(finalStr.endsWith(".ufo")){
      iconImg = "ufo";
    }else if(finalStr.endsWith(".eps")){
      iconImg = "eps";
    }else if(finalStr.endsWith(".ai")){
      iconImg = "ai";
    }else if(finalStr.endsWith(".raw")){
      iconImg = "raw";
    }else if(finalStr.endsWith(".apng")){
      iconImg = "apng";
    }else if(finalStr.endsWith(".psd")){
      iconImg = "psd";
    }else{
      isImageBool = false;
    }

    return isImageBool;
  }

  bool isVideoBool(String endStr){

    String iconImg = '';

    String finalStr = endStr;
    bool isImageBool = true;
    if(finalStr.toLowerCase().endsWith(".mp3")){
      iconImg = "mp3";
    }else if(finalStr.endsWith(".mp4")){
      iconImg = "mp4";
    }else if(finalStr.endsWith(".avi")){
      iconImg = "avi";
    }else if(finalStr.endsWith(".mpeg")){
      iconImg = "mpeg";
    }else if(finalStr.endsWith(".mpg")){
      iconImg = "mpg";
    }else if(finalStr.endsWith(".mov")){
      iconImg = "mov";
    }else if(finalStr.endsWith(".ram")){
      iconImg = "ram";
    }else if(finalStr.endsWith(".swf")){
      iconImg = "swf";
    }else if(finalStr.endsWith(".flv")){
      iconImg = "flv";
    }else if(finalStr.endsWith(".3gp")){
      iconImg = "3gp";
    }else if(finalStr.endsWith(".fpx")){
      iconImg = "fpx";
    }else if(finalStr.endsWith(".mkv")){
      iconImg = "mkv";
    }else if(finalStr.endsWith(".ogg")){
      iconImg = "ogg";
    }else if(finalStr.endsWith(".m4v")){
      iconImg = "m4v";
    }else if(finalStr.endsWith(".wmv")){
      iconImg = "wmv";
    }else if(finalStr.endsWith(".asf")){
      iconImg = "asf";
    }else if(finalStr.endsWith(".f4v")){
      iconImg = "f4v";
    }else if(finalStr.endsWith(".rmvb")){
      iconImg = "rmvb";
    }else if(finalStr.endsWith(".rm")){
      iconImg = "rm";
    }else{
      isImageBool = false;
    }

    return isImageBool;
  }

  CodeBean isCodeLanguageType(String endStr){

    CodeBean codeBean = CodeBean(json, "");
    String codeDemo = "//这里写点什么";
    String finalStr = endStr;
    Mode language = json;

    List<String> codeKeyWordsArr = [];

    codeKeyWordsArr = ["if","else","switch","case","default","break","return","goto",
      "do","while","for","continue","typedef","struct","enum","union",
      "char","short","int","long","float","double","void","sizeof",
      "signed","unsigned","const","auto","register","static","extern","volatile",
      //above c

      "fallthrough","type","var","map","func","interface","import","package",
      "defer","go","select","chan",
      //above go

      "deferred","as","assert","dynamic","sync","async","in","await",
      "export","library","external","factory","operator","part","rethrow","covariant",
      "set","yield","get",
      //above dart

    "abstract","boolean","break","byte","case","catch","class","default","do","double",
      "else","extends","final","finally","float","for","if","implements","int","instanceof",
      "long","native","new","package","private","protected","public","short","static","strictfp",
      "super","switch","synchronized","this","throw","throws","transient","try","void","volatile","while",
      //above java
    ];

    if(finalStr.toLowerCase().endsWith(".h")){
      language = objectivec;
    }else if(finalStr.toLowerCase().endsWith(".m")){
      language = objectivec;
    }else if(finalStr.toLowerCase().endsWith(".mm")){
      language = cmake;
    }else if(finalStr.toLowerCase().endsWith(".c")){
      language = cmake;
    }else if(finalStr.toLowerCase().endsWith(".cpp")){
      language = cmake;
    }else if(finalStr.endsWith(".swift")){
      language = swift;
      codeDemo = "import UIKit"
          ""
          ""
          "\nclass ThirdScrollImageView: UIView {"
          "\n"
          "\n  override init(frame: CGRect) {"
          "\n  super.init(frame: frame)"
          "\n"
          "\n  self.backgroundColor = .white"
          "\n  setUI()"
          "\n  }"
          "\n"
          "\n  required init?(coder aDecoder: NSCoder) {"
          "\n  fatalError('init(coder:) has not been implemented')"
          "\n  }"
          "\n"
          "\n  func setUI()  {"
          "\n"
          "\n    let cyclePictureView: UIView = UIView(frame: CGRect(x: 15, y: 0, width: 100, height: 100))"
          "\n    self.addSubview(cyclePictureView)"
          "\n    }"
          "\n}";

    }else if(finalStr.endsWith(".html")){
      language = xml;
      codeDemo = "<!DOCTYPE HTML>"
          "\n<html>"
          "\n<head>"
          "\n<style>"
          "\n  .cities {"
          "\n     background-color:black;"
          "\n     color:white;"
          "\n     margin:20px;"
          "\n     padding:20px;"
          "\n  }"
          "\n</style>"
          "\n</head>"
          ""
          "\n<body>"
          "\n    <div class=\"cities\">"
          "\n       <h2>我的第一个Hello, World!</h2>"
          "\n       <p>"
          "\n          Hello, World!"
          "\n       </p>"
          "\n    </div>"
          "\n</body>"
          "\n</html>"
          "\n";

    }else if(finalStr.endsWith(".java")){
      language = java;
      codeDemo = "public class HelloWorld {"
          "\n  public static void main(String[] args) {"
          "\n    System.out.println('Hello World');"
          "\n    }"
          "\n  }"
          "\n"
          "\n";
    }else if(finalStr.endsWith(".py")){
      language = python;
      codeDemo = "#!/usr/bin/python"
          "\n"
          "\nprint('Hello, World!')"
          ""
          ""
          "";

    }else if(finalStr.endsWith(".asp")){
      language = xml;
      codeDemo = "<html>"
          "\n<body>"
          "\n"
          "\n<%"
          "\nresponse.write('Hello World!')"
          "\n%>"
          "\n"
          "\n</body>"
          "\n</html>"
          "\n";
    }else if(finalStr.endsWith(".js")){
      language = javascript;
      codeDemo = "body {"
          "\n  color: #000;"
          "\n  background: #fff;"
          "\n  margin: 0;"
          "\n  padding: 0;"
          "\n  font-family: Georgia, Palatino, serif;"
          "\n}"
          "\n"
          "\n";
    }else if(finalStr.endsWith(".go")){
      language = go;
      codeDemo = "package main"
          "\n"
          "\nimport \"fmt\""
          "\n"
          "\nfunc main() {"
          "\n  fmt.Println('Hello, World!')"
          "\n}";
    }else if(finalStr.endsWith(".dart")){
      language = dart;
      codeDemo = "import 'package:flutter/cupertino.dart';"
          "\n"
          "\n"
          "\nclass Demo extends StatefulWidget {"
          "\nconst Demo({super.key});"
          "\n"
          "\n@override"
          "\nState<Demo> createState() => _DemoState();"
          "\n}"
          "\n"
          "\nclass _DemoState extends State<Demo> {"
          "\n@override"
          "\nWidget build(BuildContext context) {"
          "\n    return const Placeholder();"
          "\n  }"
          "\n}"
          ""
          "";

    }else if(finalStr.endsWith(".rs")){
      language = rust;
    }else if(finalStr.endsWith(".rb")){
      language = ruby;
    }else if(finalStr.endsWith(".php")){
      language = php;
      codeDemo = "<!DOCTYPE html>"
          "\n<html>"
          "\n<body>"
          "\n"
          "\n<?php"
          "\necho '我的第一段 PHP 脚本！';"
          "\n?>"
          "\n"
          "\n</body>"
          "\n</html>";
    }else if(finalStr.endsWith(".vue")){
      language = vue;
      codeDemo = "<div id='app'>"
          "\n</div>"
          "\n<script>"
          "\n"
          "\nnew Vue({"
          "\n el: '#app',"
          "\n data: {"
          "\n  message: '<h1>菜鸟教程</h1>'"
          "\n }"
          "\n})"
          "\n</script>";

    }else if(finalStr.endsWith(".txt")){
      language = tex;
    }else if(finalStr.endsWith(".sql")){
      language = sql;
    }else if(finalStr.endsWith(".sqf")){
      language = sqf;
    }else if(finalStr.endsWith(".sh")){
      language = shell;
    }else if(finalStr.endsWith(".pl")){
      language = perl;
    }else if(finalStr.endsWith(".lua")){
      language = lua;
    }else if(finalStr.endsWith(".kt")){
      language = kotlin;
      codeDemo = "class Greeter(val name: String) {"
          "\n fun greet() {"
          "\n   println('Hello, \$name')"
          "\n   }"
          "\n }"
          "\n"
          "\n fun main(args: Array<String>) {"
          "\n   Greeter('World!').greet()  // 创建一个对象不用 new 关键字"
          "\n  }"
          "\n";
    }else if(finalStr.endsWith(".json")){
      language = json;
      codeDemo = "{"
          "\n  code:'200',"
          "\n  data:["
          "\n    {"
          "\n      img:'xxxxxxx.jpg'"
          "\n    }"
          "\n  ]"
          "\n}";
    }else if(finalStr.endsWith(".dpr")){
      language = delphi;
    }else if(finalStr.endsWith(".cs")){
      language = cs;
    }else if(finalStr.endsWith(".vb")){
      language = basic;
    }else if(finalStr.endsWith(".xml")){
      language = xml;
      codeDemo = "<note>"
          "\n<to>George</to>"
          "\n<from>John</from>"
          "\n<heading>Reminder</heading>"
          "\n<body>Don't forget the meeting!</body>"
          "\n</note>";
    }else if(finalStr.endsWith(".plist")){
      language = xml;
      codeDemo = "<?xml version='1.0' encoding='UTF-8'?>"
          "\n<!DOCTYPE plist PUBLIC '-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd'>"
          "\n/<plist version='1.0'>"
          "\n<dict>"
          "\n<key>CFBundleInfoDictionaryVersion</key>"
          "\n<string>6.0</string>"
          "\n<key>LSRequiresIPhoneOS</key>"
          "\n<true/>"
          "\n<key>UISupportedInterfaceOrientations~ipad</key>"
          "\n<array>"
          "\n<string>UIInterfaceOrientationPortrait</string>"
          "\n<string>UIInterfaceOrientationPortraitUpsideDown</string>"
          "\n<string>UIInterfaceOrientationLandscapeLeft</string>"
          "\n<string>UIInterfaceOrientationLandscapeRight</string>"
          "\n</array>"
          "\n</dict>"
          "\n</plist>";

    }else if(finalStr.endsWith(".xcworkspacedata") || finalStr.endsWith(".xcbkptlist") || finalStr.endsWith(".storyboard")){
      language = xml;
      codeDemo = "";
    }else if(finalStr.endsWith(".yaml")){
      language = yaml;
    }else{
      language = json;
    }

    codeBean.mode = language;
    codeBean.codeDemo = codeDemo;
    codeBean.codeKeywordsArr = codeKeyWordsArr;
    return codeBean;
  }
// ------------------------------------MotionToast------------------------------------
  void displaySuccessMotionToast(BuildContext context) {
    MotionToast toast = MotionToast.success(
      title: const Text(
        'Lorum Ipsum',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor, sed do eiusmod tempor, sed do eiusmod tempor',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.rtl,
      animationType: AnimationType.fromRight,
      dismissable: true,
    );
    toast.show(context);
    Future.delayed(const Duration(seconds: 4)).then((value) {
      toast.dismiss();
    });
  }

  void _displayWarningMotionToast(BuildContext context) {
    MotionToast.warning(
      title: const Text(
        'Warning Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('This is a Warning'),
      animationCurve: Curves.bounceIn,
      borderRadius: 0,
      animationDuration: const Duration(milliseconds: 1000),
    ).show(context);
  }

  void _displayErrorMotionToast(BuildContext context) {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Please enter your name'),
      position: MotionToastPosition.top,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: false,
    ).show(context);
  }

  void displayInfoMotionToast(BuildContext context,String text,String dec) {
    MotionToast.info(
      title: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      position: MotionToastPosition.center,
      description: Text(dec),
    ).show(context);
  }

  void _displayDeleteMotionToast(BuildContext context) {
    MotionToast.delete(
      title: const Text(
        'Deleted',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('The item is deleted'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  void _displayResponsiveMotionToast(BuildContext context) {
    MotionToast(
      icon: Icons.rocket_launch,
      primaryColor: Colors.purple,
      title: const Text(
        'Custom Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text(
        'Hello my name is Flutter dev',
      ),
    ).show(context);
  }

  void displayCustomMotionToast(BuildContext context,String text,String dec) {
    MotionToast(
      primaryColor: Colors.pink,
      title: const Text(
        'Bugatti',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      dismissable: false,
      description: const Text(
        'Automobiles Ettore Bugatti was a German then French manufacturer of high-performance automobiles. The company was founded in 1909 in the then-German city of Molsheim, Alsace, by the Italian-born industrial designer Ettore Bugatti. ',
      ),
    ).show(context);
  }

  void _displayMotionToastWithoutSideBar(BuildContext context) {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.orange[500]!,
      secondaryColor: Colors.grey,
      backgroundType: BackgroundType.solid,
      title: const Text('Two Color Motion Toast'),
      description: const Text('Another motion toast example'),
      displayBorder: true,
      displaySideBar: false,
    ).show(context);
  }

  void displayMotionToastWithBorder(BuildContext context) {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.deepOrange,
      title: const Text('Top Motion Toast'),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      displayBorder: true,
      width: 350,
      height: 100,
      padding: const EdgeInsets.only(
        top: 30,
      ),
    ).show(context);
  }

  void _displayTwoColorsMotionToast(BuildContext context) {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.orange[500]!,
      secondaryColor: Colors.grey,
      backgroundType: BackgroundType.solid,
      title: const Text(
        'Two Color Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      width: 350,
      height: 100,
    ).show(context);
  }

  void _displayTransparentMotionToast(BuildContext context) {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.grey[400]!,
      secondaryColor: Colors.yellow,
      backgroundType: BackgroundType.transparent,
      title: const Text(
        'Two Color Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.center,
      width: 350,
      height: 100,
    ).show(context);
  }

  void _displaySimultaneouslyToasts(BuildContext context) {
    MotionToast.warning(
      title: const Text(
        'Warning Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('This is a Warning'),
      animationCurve: Curves.bounceIn,
      borderRadius: 0,
      animationDuration: const Duration(milliseconds: 1000),
    ).show(context);
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Please enter your name'),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }
// ------------------------------------MotionToast------------------------------------

  Color getRandomColor(double opacity) {
    return Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
        Random().nextInt(256), opacity);
  }

  Future<bool> simpleDialog(BuildContext context,FileSaveManager fileSaveManager) async {
    bool state = false;
    var result = await showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            title: const Column(
              children: [
                Text("是否保存已经编辑的文件？",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.white)),
                Text("to save the edited file ？",textAlign: TextAlign.center,style: TextStyle(fontSize: 10,color: Colors.grey)),
              ],
            ),
            backgroundColor: const Color.fromRGBO(62, 62, 62, 0.95),
            children: [
            const Divider(color: Colors.grey,),
              SizedBox(
                width: 350,
                // padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text(fileSaveManager.path,textAlign: TextAlign.left,style: const TextStyle(fontSize: 12,color: Colors.white),),
              ),
              const Divider(color: Colors.grey,),
              SizedBox(
                height: 24,
                // padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          print("不保存(No)");
                          state = false;
                          Navigator.pop(context, "不保存");
                        },
                        child: const Text("不保存(No)",style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          print("保存文件");
                          state = true;
                          Navigator.pop(context, "保存文件");
                        },
                        child: const Text("保存文件(Save)",style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
    return state;
  }
  //开屏展示宣传页面
  Container buildOpenScreenContainer(String type,double width, double height,BuildContext context,{required MyCallBackListener? callBackListener}) {
    return Container(
      width: width,
      height: height,
      color: systemModeColorChangeState(context,const Color.fromRGBO(255, 255, 255, 1),const Color.fromRGBO(40, 37, 36, 1)),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Container(
                // color: Colors.red,
                margin:
                const EdgeInsets.only(left: 5, right: 5),
                width: 120,
                height: 120,
                child: Image.asset("images/1024x1024icon.png"),
              ),
              Container(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "CODE MAKER",
                    style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white70),fontSize: 50,fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text:"\n"),
                      TextSpan(
                        text: "2024" ,
                        style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white70),fontSize: 18,fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: "      版本  v1.0.1" ,
                        style: TextStyle(color: systemModeColorChangeState(context,Colors.black,Colors.white38),fontSize: 12,fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
          Positioned(
            top: 10,
            right: 5,
              child: TextButton(onPressed: (){
                if(type == "1"){
                  callBackListener?.myCallBack("1", "0", "0");
                }else{
                  Navigator.pop(context);
                }
          }, child: Icon(Icons.clear,size: 20,color:systemModeColorChangeState(context,Colors.black,Colors.white),)))
        ],
      )
    );
  }

  //安全锁屏页面
  Container buildLockScreenContainer(bool homeScreenHasPasswordBool,double width, double height,BuildContext context,{required MyCallBackListener callBackListener}) {

    String reminderStr = "";
    if(!homeScreenHasPasswordBool){
      reminderStr = "请设置安全锁密码";
    }else{
      reminderStr = "It's in a security lock   正在安全锁定中";
    }

    TextEditingController textEditingController = TextEditingController(text:"");
    TextEditingController textEditingController2 = TextEditingController(text:"");

    return Container(
        width: width,
        height: height,
        color: const Color.fromRGBO(40, 37, 36, 0.5),
        alignment: Alignment.center,
        child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10
            ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  Container(
                    // color: Colors.red,
                    margin:
                    const EdgeInsets.only(left: 5, right: 5),
                    width: 120,
                    height: 120,
                    child: Image.asset("images/1024x1024icon.png"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: RichText(
                      text:  TextSpan(
                        text: reminderStr,
                        style: const TextStyle(color: Colors.white70,fontSize: 14,fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),
                  Container(
                    width: 200 + 10 + 60,
                    margin: const EdgeInsets.only(top: 10),
                    child:  Column(
                      children: [
                        Container(
                          height: 30,
                          width: 200,
                          alignment: Alignment.center,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 0.5)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 0.5),
                                // borderRadius: BorderRadius.circular(2.0)
                              ),
                              hintText: '请输入安全锁密码',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 0.5),
                                // borderRadius: BorderRadius.circular(2.0)
                              ),
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        !homeScreenHasPasswordBool ?
                        Container(
                          width: 0,
                          height: 0,
                          color: Colors.transparent,
                        ) :
                        Container(
                          width: 60,
                          height: 30,
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue,
                          ),
                          child: TextButton(onPressed: (){

                            callBackListener.myCallBack("0", textEditingController.text, "0");
                          }, child: const Text("进入",style: TextStyle(color: Colors.white,fontSize: 12,),textAlign: TextAlign.center,)),
                        )
                      ],
                    ),
                  ),
                  homeScreenHasPasswordBool ?
                  Container(
                    width: 0,
                    height: 0,
                    color: Colors.transparent,
                  ) :
                  Container(
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: 200,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 10),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: textEditingController2,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 0.5)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 0.5),
                                  // borderRadius: BorderRadius.circular(2.0)
                                ),
                                hintText: '请再次输入安全锁密码',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 0.5),
                                  // borderRadius: BorderRadius.circular(2.0)
                                ),
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: Row(
                                children: [
                                  // Spacer(),
                                  Container(
                                    width: 90,
                                    height: 40,
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.blue,
                                    ),
                                    child: TextButton(onPressed: (){
                                      print("-=-=-textEditingController=-${textEditingController.text}=-=-=-${textEditingController2.text}=-=-=-=-=");
                                      callBackListener.myCallBack("3", "", "0");
                                    }, child: const Text("取消",style: TextStyle(color: Colors.white,fontSize: 12,),textAlign: TextAlign.center,)),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 90,
                                    height: 40,
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.blue,
                                    ),
                                    child: TextButton(onPressed: (){
                                      print("-=-=-textEditingController=-${textEditingController.text}=-=-=-${textEditingController2.text}=-=-=-=-=");
                                      if(textEditingController.text == textEditingController2.text && textEditingController2.text.isNotEmpty){
                                        callBackListener.myCallBack("1", textEditingController.text, "0");
                                      }
                                    }, child: const Text("确定",style: TextStyle(color: Colors.white,fontSize: 12,),textAlign: TextAlign.center,)),
                                  ),
                                  // Spacer(),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  const Spacer()
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class CodeBean {
  late Mode mode; //语言类型
  late String codeDemo; //默认代码
  late List<String> codeKeywordsArr; //默认关键字

  CodeBean(this.mode, this.codeDemo);
}

//---------------  file infor class ------------------
class FolderBean {
  late String foldUrlStr; //路径
  late List<FolderBean> folderArr; //子文件夹
  late List<FileBean> fileArr; //子具体文件
  late bool foldOpenBool; //展开

  FolderBean(this.foldUrlStr, this.folderArr, this.fileArr, this.foldOpenBool);
}

class FileBean {
  late String foldUrlStr; //路径
  late double fileSize; //文件大小
  late String filePreName; //文件前缀名称
  late String fileSufferName; //文件后缀名称

  FileBean(this.foldUrlStr, this.fileSize, this.filePreName, fileSufferName);
}

class FileSaveManager {
  late String path; //路径
  late String fileDefaultContent; //文件原始内容
  late String fileNewContent; //文件原始内容
  late bool needSaveBool; //是否需要保存
  late bool canOpenBool; //是否能够读写

  void fileBecomeDefault(){
    path = "";
    fileDefaultContent = "";
    fileNewContent = "";
    needSaveBool = false;
    canOpenBool = false;
  }

  FileSaveManager(this.path,this.fileDefaultContent,this.fileNewContent, this.needSaveBool,this.canOpenBool);
}

//---------------  file infor class ------------------
