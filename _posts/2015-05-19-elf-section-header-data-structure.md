---
layout: post
title: "ELF Section Header Data Structure"
date: 2015-05-19
description: ""
category: 
tags: []
---

# ELF Section Header的结构

我们以32位作为平台框架去解释，

```c
typedef struct
{
	Elf32_Word sh_name;      /* Section name (string tbl index)   */
	Elf32_Word sh_type;      /* Section type                      */
	Elf32_Word sh_flags;     /* Section flags                     */
	Elf32_Addr sh_addr;      /* Section virtual addr at execution */
	Elf32_Off sh_offset;     /* Section file offset               */
	Elf32_Word sh_size;      /* Section size in bytes             */
	Elf32_Word sh_link;      /* Link to another section           */
	Elf32_Word sh_info;      /* Additional section information    */
	Elf32_Word sh_addralign; /* Section alignment                 */
	Elf32_Word sh_entsize;   /* Entry size if section holds table */
} Elf32_Shdr;
```

整个section header table就是一个数组，数组的每一个元素就是Elf32_Shdr(以32bit为例)。Elf32_Shdr仅仅是section的一个索引，包括一些属性信息，并不是section本省。简单的介绍一下各个元素的含义。

sh_name: section name。不过其实sh_name中存放的不是字符串，而是 index，这一点从sh_name是定长应该能看出来，那么index又是什么意思呢？

index的含义是在string table（其实它也是一个section header）中的第几个字节数。其实是这样的，所有的section name都存放在一个叫做string table的表中，index就是该section名字的第一个字符在表中的位置，名字一直到遇到一个'\0'为止结束。至于string table怎么找，还记得elf header中的e_shstrndx成员吗？它就指明了string table是在section header table中的第几个入口。sh_offset:这个元素就指明了这个Elf32_Shdr描述的section在文件中的偏移量。这样就可以找到对应的位置了！

```c
/* move point to string table section offset in file */
fseek(fp, elfheader.e_shoff + 
          elfheader.e_shstrndx * elfheader.e_shentsize, SEEK_SET);
/* get the entry:section name string table in section header table */
fread(&strhdr, sizeof(char), sizeof(strhdr), fp); 
/* move file point to string table section content in file */
fseek(fp, strhdr.sh_offset, SEEK_SET);
strtable = (unsigned char *)malloc(sizeof(unsigned char) * 
                                   strhdr.sh_size);
/* read the content of section name string table */
fread(strtable, sizeof(char), strhdr.sh_size, fp);
/* move file point to offset of section header table */
fseek(fp, elfheader.e_shoff, SEEK_SET);
/* set section header entry numbers to loop */
shnum = elfheader.e_shnum;
printf("There are %d section headers, starting at offset 0x%lux\n",
		        shnum,elfheader.e_shoff);
while(shnum != 0){
	fread(&shdr, sizeof(char), sizeof(shdr), fp);
	printf("sh_name : %s\n", strtable+shdr.sh_name);
	printf("sh_type : %u\n", shdr.sh_type);
	......
	shnum--;
}
```
