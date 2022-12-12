import subprocess

process = subprocess.Popen("git rev-list --all --max-count=100 --pretty=oneline --in-commit-order", shell=True,
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=None)
limit_char = 250
break_count = 0
output = []
limit_count = 0
while True:
    next_line = process.stdout.readline()
    if next_line:
        comment = " "
        array_comment = str(next_line).split(" ")[1:]
        result = str(comment.join(array_comment))
        if 'merge branch' in result.lower() and 'staging' in result.lower() and 'master' in result.lower():
            break_count += 1
        if break_count == 2:
            break
        if not ('merge' in result.lower()):
            output.append(result.rstrip().lower().strip())
    elif not process.poll():
        break
    limit_count += 1
    if limit_count >= 100:
        break

clean = list(dict.fromkeys(output))
clean.sort()
count_char = 0
for value in clean:
    count_char += len(value)
    if count_char >= limit_char:
        break
    else:
        import re
        final = re.sub("[^0-9a-zA-Z]+", " ", value)
        final = str(value).replace('\n','')
        final = final.replace("\n'",'')
        final = final.replace('\\n','')
        final = final.replace("\\n'",'')
        final = final.replace("'",'')
        final = final.replace(":",' ')
        final = final.replace("(",' ')
        final = final.replace(")",' ')
        print(final)
