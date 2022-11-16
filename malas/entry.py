from subprocess import PIPE, Popen

def getTracerouteResult(target):
    command = './malas/asroute.sh ' + target + ' NO'
    process = Popen(command, stdout=PIPE, stderr=None, shell=True)
    output = process.communicate()[0].decode("utf-8")
    output = str(output).replace("\n", "").split(" ")
    return output