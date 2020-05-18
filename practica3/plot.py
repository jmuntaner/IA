import matplotlib.pyplot as plt
import sys
import numpy

if len(sys.argv) < 2:
    print('Usage: python3 {} [file] [optional:save file]'.format(sys.argv[0]))
    exit(-1)

record = {}

with open(sys.argv[1]) as f:
    for line in f:
        s = line.split(' ')
        try:
            i = int(s[0])
            v = float(s[1].replace(',', '.'))
            if i not in record:
                record[i] = []
            record[i].append(v)
        except:
            pass

x = []
y = []
for i, v in record.items():
    x.append(i)
    y.append(sum(v)/len(v))

a = numpy.polyfit(numpy.array(x), numpy.log(numpy.array(y)), 1, w=numpy.sqrt(y))

xfit = numpy.arange(0.0, x[-1], 0.01)
yfit = numpy.exp(a[1]) * numpy.exp(a[0] * xfit)

plt.plot(x, y)
plt.plot(xfit, yfit)
plt.legend(['Time', 'Exponential fit'])


if len(sys.argv) > 2:
    plt.savefig(sys.argv[2] + '.eps', format='eps', dpi=1000)
else:
    plt.show()

