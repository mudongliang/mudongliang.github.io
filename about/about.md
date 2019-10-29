---
layout: page
title: About Me
permalink: /about/
---

* TOC
{:toc}

### Basic Information

My name is **Dongliang Mu**. I am on the job market this year. Please feel free to download [my CV]({{site.url}}/files/DongliangMu_CV.pdf).

- Education 
	- Undergraduate (2010.09 - 2014.06), Computer Science and Technology, Zhengzhou University
	- Ph.D (2014.09 - Now), Computer Science and Technology, Nanjing University
- Major field : **Software Security & System Security**
	- Vulnerability Reproduction
	- Postmortem Program Analysis
	- Vulnerability Diagnose
	- Binary Analysis

### Experience

- Research Assistant in Pennsylvania State University (2016 - 2020)
	- Adviser: [Dr. Xinyu Xing](http://xinyuxing.org/)
	- Topic: **Diagnose on process/OS crashes/panics**

- Talk in the GeekPwn China 2018 in Shanghai
	- Name: From Physical Security to Cyber Security: How to forge data spoofing personalized auto insurance

- Organizer of 2018 Penn State Cybersecurity Competition in Pennsylvania State University
	- HomePage : <https://psusecurity.github.io/>

### Publications

1. CREDAL: Towards Locating a Memory Corruption Vulnerability with Your Core Dump [\[Paper\]]({{site.url}}/files/papers/p529-xu.pdf)  
Jun Xu, **Dongliang Mu**, Ping Chen, Xinyu Xing, Pei Wang, Peng Liu  
Proceedings of the 23nd ACM Conference on Computer and Communications Security (**ACM CCS 2016**)

2. POMP: Postmortem Program Analysis with Hardware-Enhanced Post-Crash Artifacts [\[Paper\]]({{site.url}}/files/papers/sec17-xu.pdf)  
Jun Xu, **Dongliang Mu**, Xinyu Xing, Peng Liu, Ping Chen, Bing Mao  
Proceedings of the 26th USENIX Security Symposium (**USENIX Security 17**)

3. ROPOB: Obfuscating Binary Code via ReturnOriented Programming [\[Paper\]]({{site.url}}/files/papers/ropob_securecomm.pdf)  
**Dongliang Mu**, Jia Guo, Wenbiao Ding, Zhilong Wang, Bing Mao, Lei Shi  
International Conference on Security and Privacy in Communication Systems (**SecureCOMM 17**)

4. DiffGuard: Obscuring Sensitive Information in Canary Based Protections [\[Paper\]]({{site.url}}/files/papers/diffguard_securecomm.pdf)  
Jun Zhu, Weiping Zhou, Zhilong Wang, **Dongliang Mu**, Bing Mao  
International Conference on Security and Privacy in Communication Systems (**SecureCOMM 17**)

5. Understanding the Reproducibility of Crowd-reported Security Vulnerabilities [\[Paper\]]({{site.url}}/files/papers/sec18-mu.pdf)  
**Dongliang Mu**, Alejandro Cuevas, Limin Yang, Hang Hu, Xinyu Xing, Bing Mao, Gang Wang  
Proceedings of the 27th USENIX Security Symposium (**USENIX Security 18**)

6. LEMNA: Explaining Deep Learning based Security Applications [\[Paper\]]({{site.url}}/files/papers/ccs18.pdf)  
Wenbo Guo, **Dongliang Mu**, Jun Xu, Purui Su, Gang Wang, Xinyu Xing  
Proceedings of The 25th ACM Conference on Computer and Communications Security (**CCS 2018**) **Outstanding paper award**

7. DEEPVSA: Facilitating Value-set Analysis with Deep Learning for Postmortem Program Analysis [\[Paper\]]({{site.url}}/files/papers/deepvsa.pdf)  
Wenbo Guo\*, **Dongliang Mu\***, Xinyu Xing, Min Du, Dawn Song  
Proceedings of the 28th USENIX Security Symposium (USENIX Security 2019)

8. Ptrix: Efficient Hardware-Assisted Fuzzing for COTS Binary [\[Paper\]]({{site.url}}/files/papers/ptrix.pdf)  
Yaohui Chen\*, **Dongliang Mu\***, Jun Xu, Zhichuang Sun, Wenbo Shen, Xinyu Xing, Long Lu, Bing Mao  
Proceedings of the 14th ACM ASIA Conference on Computer and Communications Security (**AsiaCCS 2019**)

9. RENN: Efficient Reverse Execution with Neural-Network-assisted Alias Analysis  
**Dongliang Mu\***, Wenbo Guo\*, Alejandro Cuevas, Yueqi Chen, Jinxuan Gai, Xinyu Xing, Bing Mao, Chengyu Song  
Proceedings of the 34th IEEE/ACM International Conference on Automated Software Engineering (**ASE 2019**)

10. POMP++: Facilitating Postmortem Program Diagnosis with Value-set Analysis  
**Dongliang Mu**, Yunlan Du, Jianhao Xu, Jun Xu, Xinyu Xing, Bing Mao, Peng Liu  
IEEE Transactions on Software Engineering (**TSE 2019**) **Accepted**

Note that \* means *equal contribution*

### Talks

- [Understanding the Reproducibility of Crowd-reported Security Vulnerabilities]({{site.url}}/files/slides/usenix18_slide.pptx)  
2018 USENIX Security in USA

- [Ptrix: Efficient Hardware-Assisted Fuzzing for COTS Binary]({{site.url}}/files/slides/asiaccs19_slide.pptx)  
2019 AsiaCCS in New Zealand

### CVEs discovered by me

|   CVE ID      | Vulnerability Type     | Vulnerable Software
| ------------- | ---------------------- | -------------------
|CVE-2018-8816  | Stack Exhaustion       | perl-5.26.1
|CVE-2018-8881  | Heap buffer overflow   | nasm-2.13.02rc2
|CVE-2018-8882  | Stack buffer overflow  | nasm-2.13.02rc2
|CVE-2018-8883  | Global buffer overflow | nasm-2.13.02rc2
|CVE-2018-10016 | Division-by-zero       | nasm-2.14rc0
|CVE-2018-9138  | Stack Exhaustion       | binutils-2.29
|CVE-2018-9996  | Stack Exhaustion       | binutils-2.29
|CVE-2018-10316 | Denial-of-Service      | nasm-2.14rc0
|CVE-2018-9251  | Denial-of-Service      | libxml2-2.9.8

### Open Source Projects

The following projects are Github / Bitbucket Repositories I maintained or contributed.

**Research Projects:**

- [LinuxFlaw](https://github.com/mudongliang/LinuxFlaw)
- [source-packages](https://github.com/mudongliang/source-packages)
- [Dockerfiles](https://github.com/mudongliang/Dockerfiles)
- [TraditionalMitigation](https://github.com/hardenedlinux/TraditionalMitigation)
- [POMP](https://github.com/junxzm1990/pomp)
- [DEEPVSA](https://github.com/Henrygwb/deepvsa)

**Book-in-progress related with Linux Kernel**

- [linux-insides](https://github.com/0xAX/linux-insides)
- [linux-insides-zh](https://github.com/MintCN/linux-insides-zh)
