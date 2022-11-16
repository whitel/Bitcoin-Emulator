from subprocess import PIPE, Popen

class ASGuard:
    def __init__(self):
        self.debug = "NO"
        # self.debug = "DEBUG"
        self.executable = './asguard/asroute.sh'
        self.as_counter = dict()

    # 使用traceroute + as whois进行路径测试（todo：使用CAIDA的数据，或者更好的方法）
    def GetTracerouteResult(self, target):
        command = self.executable + ' ' + target + ' ' + self.debug
        process = Popen(command, stdout=PIPE, stderr=None, shell=True)
        output = process.communicate()[0].decode("utf-8")
        return output.replace("\n", "").split(" ")

    def Add(self, asn):
        pass


    def Delete(self, asn):
        pass


    # 测试目标IP是否会触发EREBUS攻击预警。如果可以安全加入则返回True，否则返回False
    def Banker(self, target):
        backup = dict(self.as_counter)

        list = self.GetTracerouteResult(target)
        for item in list:
            if(item in backup):
                backup[item] += 1
            else:
                backup[item] = 1

        # n为待测阈值，暂定为10
        n = 10
        for item in backup:
            if(backup[item] > n):
                return False

        self.as_counter = dict(backup)
        return True
