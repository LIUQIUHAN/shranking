import sys
import getopt
from ChineseTone import *

# PinyinHelper.addWordPinyin('海都', ['hai', 'du'])

# pinyin.py -f 文件名

# 将汉字转换为拼音，形式为 ChongQing
def convStr(val):
	ps = PinyinHelper.convertToPinyinFromSentence(val, pinyinFormat=PinyinFormat.WITHOUT_TONE)
	return ''.join(map(lambda s: s.capitalize(), ps))

# 读取文件，然后输出到文件
def convFile(filePath):
	str = ''
	# print('读取文件，filePath=', filePath)
	with open(filePath, 'r') as f:
		str = f.read()
	if not str:
		print('文件内容为空')
	# print(convStr(str))
	with open(filePath+'.pinyin', 'w') as f:
		f.write(convStr(str))


# 读取命令行参数，执行功能
try:
	options,args = getopt.getopt(sys.argv[1:],"s:f:", ["str=","file="])
except getopt.GetoptError:
	sys.exit()
for name, value in options:
	if name in ("-s","--str"):
		# print('input string:', value)
		print(convStr(value))
	if name in ("-f","--file"):
		# print('input file:', value)
		convFile(value)



"""


print(','.join(PinyinHelper.convertToPinyinFromSentence('了解了', pinyinFormat=PinyinFormat.WITHOUT_TONE)))

map(lambda s: s.capitalize(), PinyinHelper.convertToPinyinFromSentence('重庆大学', pinyinFormat=PinyinFormat.WITHOUT_TONE))


ps = PinyinHelper.convertToPinyinFromSentence('重庆大学', pinyinFormat=PinyinFormat.WITHOUT_TONE)
map(lambda s: s.capitalize(), ps)


print(''.join(map(lambda s: s.capitalize(), ps)))



print(''.join(map(lambda s: s.capitalize(), PinyinHelper.convertToPinyinFromSentence('重庆大学\n厦门大学', pinyinFormat=PinyinFormat.WITHOUT_TONE))))
"""

