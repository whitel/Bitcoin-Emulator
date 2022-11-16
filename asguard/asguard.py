from subprocess import PIPE, Popen

class ASGuard:
    def __init__(self):
        pass

    def getTracerouteResult(self, target):
        command = './asguard/asroute.sh ' + target + ' NO'
        process = Popen(command, stdout=PIPE, stderr=None, shell=True)
        output = process.communicate()[0].decode("utf-8")
        output = str(output).replace("\n", "").split(" ")
        return output