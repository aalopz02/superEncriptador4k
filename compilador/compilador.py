def tokenize(line,tagDict,numLine):
    inst = line.lower()
    if ':' in inst:
        inst = inst.replace(':','')
        inst = inst.replace('\n','')
        tagDict[inst] = numLine
        return []
    elif "j" in inst:
        aux = inst.split()
        inst = ["j", tagDict[aux[1]]]
    else:
        inst = inst.replace('#','')
        inst = inst.replace(',',' ')
        inst = inst.split()
    return inst

def complement16(binLines):
    for i in range(len(binLines)):
        lenLine = len(binLines[i])
        if lenLine < 16:
            for j in range(16 - lenLine):
                binLines[i] = binLines[i] + "0"
        elif lenLine > 16:
            print("Incorrect Structure, please review")
            print("0 fill")
            quit()
    

def getInst(filename):
    instList = []
    tagDict = {}
    insts = open(filename,"r")
    lenAux = open(filename,"r")
    length = len(lenAux.readlines())
    for i in range(length):
        instList.append(tokenize(insts.readline(),tagDict,i))
    return writeMif(instList)

def writeMif(instList):
    binLines = []
    for inst in instList:
        if len(inst)>0:
            if "add" in inst[0]:
                processAdd(binLines,inst)
            elif "sub" in inst[0]:
                processSub(binLines,inst)
            elif "vxor" in inst[0]:
                processVxor(binLines,inst,"00")
            elif "vld" in inst[0]:
                processVld(binLines,inst,"00")
            elif "vstr" in inst[0]:
                processVstr(binLines,inst,"00")
            elif "vsr" in inst[0]:
                processVsr(binLines,inst,"00")
            elif "vsl" in inst[0]:
                processVsr(binLines,inst,"00")
            elif "vswap" in inst[0]:
                processVswap(binLines,inst,"00")
            elif "j" in inst[0]:
                processJump(binLines,inst,"00")
            elif "cmp" in inst[0]:
                processCmp(binLines,inst,"00")
            elif "nop" in inst[0]:
                binLines.append("0000000000000000")
            elif "end" in inst[0]:
                binLines.append("0000000000001101")
            else:
                print("Incorrect Structure, please review")
                print("Inst:",inst)
                print("mif fill")
                quit()
    complement16(binLines)
    lenBinLines = len(binLines)
    memLen = 512
    f = open("inst.mif","w")
    f.write("WIDTH=16;\n")
    f.write("DEPTH={};\n\n".format(memLen))
    f.write("ADDRESS_RADIX=UNS;\n")
    f.write("DATA_RADIX=BIN;\n\n")
    f.write("CONTENT BEGIN\n")
    for i in range(lenBinLines):
        f.write("\t{}\t:\t{};\n".format(i,binLines[i]))
    f.write("\t[{}..{}]\t:\t0;\n".format(lenBinLines,memLen-1))
    f.write("END;")
    f.close()


def processCondCode(inst):
    if "ne" in inst[0]:
        inst[0] = inst[0].replace("ne",'')
        return "11"
    elif "eq" in inst[0]:
        inst[0] = inst[0].replace("eq",'')
        return "00"
    elif "gt" in inst[0]:
        inst[0] = inst[0].replace("gt",'')
        return "01"
    elif "al" in inst[0]:
        inst[0] = inst[0].replace("al",'')
        return "10"
    else:
        print("Incorrect Structure, please review")
        print("cond code")
        print("Inst:",inst)
        quit()

def processReg(reg):
    if '10' in reg:
        return '1010'
    elif '11' in reg:
        return '1011'
    elif '12' in reg:
        return '1100'
    elif '13' in reg:
        return '1101'
    elif '14' in reg:
        return '1110'
    elif '15' in reg:
        return '1111'
    elif '0' in reg:
        return '0000'
    elif '1' in reg:
        return '0001'
    elif '2' in reg:
        return '0010'
    elif '3' in reg:
        return '0011'
    elif '4' in reg:
        return '0100'
    elif '5' in reg:
        return '0101'
    elif '6' in reg:
        return '0110'
    elif '7' in reg:
        return '0111'
    elif '8' in reg:
        return '1000'
    elif '9' in reg:
        return '1001'
    else:
        print("Incorrect Structure, please review")
        print("reg code")
        print("Inst:",inst)
        quit()

def processVect(vect):
    if '0' in vect:
        return '00'
    elif '1' in vect:
        return '01'
    elif '2' in vect:
        return '10'
    elif '3' in vect:
        return '11'
    else:
        print("Incorrect Structure, please review")
        quit()

def processImm(imm, bits):
    num = int(imm)
    binStr = bin(num).replace('0b','')
    binLen = len(binStr)
    if binLen < bits:
        for i in range(bits - binLen):
            binStr = '0' + binStr
    elif binLen > bits:
        print("Incorrect Structure, please review")
        print("imm code")
        print("Inst:",inst)
        quit()
    return binStr
        
def processAdd(binLines,inst):
    if inst[0] == "add":
        rd = processReg(inst[1])
        op1 = processReg(inst[2])
        op2 = processReg(inst[3])
        post = "1001"
        res = rd + op1 + op2 + post
        binLines.append(res)
    elif inst[0] == "addi":
        rd = processReg(inst[1])
        op1 = processReg(inst[2])
        imm = processImm(inst[3],4)
        post = "1011"
        res = rd + op1 + imm + post
        binLines.append(res)
    else:
        print("Incorrect Structure, please review")
        print("add code")
        print("Inst:",inst)
        quit()

def processSub(binLines,inst):
    if inst[0] == "sub":
        rd = processReg(inst[1])
        op1 = processReg(inst[2])
        op2 = processReg(inst[3])
        post = "1010"
        res = rd + op1 + op2 + post
        binLines.append(res)
    elif inst[0] == "subi":
        rd = processReg(inst[1])
        op1 = processReg(inst[2])
        imm = processImm(inst[3],4)
        post = "1100"
        res = rd + op1 + imm + post
        binLines.append(res)
    else:
        print("Incorrect Structure, please review")
        print("sub code")
        print("Inst:",inst)
        quit()

def processVxor(binLines,inst,condCode):
    if inst[0] == "vxor":
        vregoper = processVect(inst[1])
        vregres = processVect(inst[2])
        reg = processReg(inst[3])
        post = "00010"
        res = condCode + "0" + vregoper + vregres + reg + post
        binLines.append(res)
    elif inst[0] == "vxori":
        vregoper = processVect(inst[1])
        vregres = processVect(inst[2])
        imm = processImm(inst[3],5)
        post = "0011"
        res = condCode + "1" + vregoper + vregres + imm + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processVxor(binLines,inst,condCode)

def processVld(binLines,inst,condCode):
    if inst[0] == "vld":
        rdir = processReg(inst[1])
        vregdest = processVect(inst[2])
        span = processImm(inst[3],3)
        post = "00100"
        res = condCode + rdir + vregdest + span + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processVld(binLines,inst,condCode)

def processVstr(binLines,inst,condCode):
    if inst[0] == "vstr":
        rdir = processReg(inst[1])
        vregdest = processVect(inst[2])
        span = processImm(inst[3],3)
        post = "00101"
        res = condCode + rdir + vregdest + span + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processVstr(binLines,inst,condCode)

def processVsr(binLines,inst,condCode):
    if inst[0] == "vsr":
        vregoper = processVect(inst[1])
        vregres = processVect(inst[2])
        reg = processReg(inst[3])
        post = "00110"
        res = condCode + "0" + vregoper + vregres + reg + post
        binLines.append(res)
    elif inst[0] == "vsl":
        vregoper = processVect(inst[1])
        vregres = processVect(inst[2])
        reg = processReg(inst[3])
        post = "00111"
        res = condCode + "0" + vregoper + vregres + reg + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processVsr(binLines,inst,condCode)

def processVswap(binLines,inst,condCode):
    if inst[0] == "vswap":
        vregoper = processVect(inst[1])
        vregdest = processVect(inst[2])
        bitOrigin = processImm(inst[3],3)
        bitDest = processImm(inst[4],3)
        post = "1000"
        res = condCode + vregoper + vregdest + bitOrigin + bitDest + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processVswap(binLines,inst,condCode)

def processJump(binLines,inst,condCode):
    if inst[0] == "j":
        imm = processImm(inst[1],10)
        post = "0001"
        res = condCode + imm + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processJump(binLines,inst,condCode)

def processCmp(binLines,inst,condCode):
    if inst[0] == "cmp":
        op1 = processReg(inst[1])
        op2 = processReg(inst[2])
        post = "000000"
        res = condCode + op1 + op2 + post
        binLines.append(res)
    else:
        condCode = processCondCode(inst)
        processCmp(binLines,inst,condCode)

getInst("demo.txt")
