#convert maize vcf to a bimbam file for gemma
# author: Emily Josephs
import sys

sys.path.append("/home/emjo/apps/PyVCF/")
import vcf

def main():
	if _args.complete or _args.missing:
		myIncomplete = open(_args.output+".incomp",'w')	

        myOut = open(_args.output,'w')

	if _args.annotation:
		myAnn = open(_args.output+".ann",'w')

	indOrder = [line.strip() for line in open(_args.indlist,'r')]
	
        genoDict = dict(zip(['./.','0/0','0/1','0/2','0/3','0/4','0/5','1/0','1/1','1/2','1/3','1/4','1/5','2/0','2/1','2/2','2/3','2/4','2/5','3/0','3/1','3/2','3/3','3/4','3/5','4/0','4/1','4/2','4/3','4/4','4/5','1','0','5/0','5/1','5/2','5/3','5/4','5/5'],['NA','0','1','NA','NA','NA','NA','1','2','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA']))

        myVcf = vcf.Reader(open(_args.vcffile, 'r'))
        for record in myVcf:
                #mySnpName = 'c' + str(record.CHROM) + 'p' + str(record.POS)
                mySnpName = record.ID
                myRef = str(record.REF)
                myAlt = str(record.ALT[0])
                myPos = str(record.POS)
		myChr = str(record.CHROM)
		locusGenos = list(get_genos(record, indOrder, genoDict))
		if _args.complete and "NA" in locusGenos:
			myIncomplete.write(','.join([mySnpName, myRef, myAlt]+locusGenos)+"\n")
                if _args.missing and locusGenos.count('NA') > 170:
			myIncomplete.write(','.join([mySnpName, myRef, myAlt]+locusGenos)+"\n")
		if _args.annotation:
			myAnn.write(','.join([mySnpName, myPos, myChr])+"\n")
			myOut.write(','.join([mySnpName, myRef, myAlt]+locusGenos)+"\n")
		else:
			myOut.write(','.join([mySnpName, myRef, myAlt]+locusGenos)+"\n")

def get_genos(l, np, gd):
        for ind in np:
                myGeno = l.genotype(ind)['GT']
                yield(gd[myGeno])

def parseArgs():
        parser = argparse.ArgumentParser(description="convert vcf to bimbam")
        parser.add_argument("-v", "--vcffile", type=str)
        parser.add_argument("-i", "--indlist", type=str)
        parser.add_argument("-o", "--output", type=str)
	parser.add_argument("-a", "--annotation", action='store_true')
        parser.add_argument("-c", "--complete", action='store_true')
        parser.add_argument("-m", "--missing", action='store_true')
        global _args
        _args = parser.parse_args()
        sys.stderr.write(str(_args)+"\n")

import argparse
_args = None

if __name__ == "__main__":
        parseArgs()
	main()
#        if _args.test:
#                import doctest
#                doctest.testmod()
#               
