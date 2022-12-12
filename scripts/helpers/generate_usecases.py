import sys, os

REPOSITORY_PATH = './lib/domain/repositories/{}_repository.dart'
USECASE_PATH = './lib/domain/usecases/{}/'
DATA_USECASE_PATH = './lib/device/usecases/{}/'


def generate_from_repository(repository):
    """
    Run using `python3 script/helpers/generate_usecases.py printer`
    or `python3 script/helpers/generate_usecases.py printer device`
    """
    usecases = []

    with open(REPOSITORY_PATH.format(repository), 'r') as repository_file:
        for line in repository_file:
            index = line.find('@')
            if index != -1:
                return_type, usecase = line[index + 1:].split()
                usecases.append(usecase)

    _generate_usecases(usecases, repository)


def _generate_usecases(usecases, repository):
    for usecase in usecases:
        _generate_usecase(usecase, repository)


def _generate_usecase(usecase, repository):
    usecase_path = DATA_USECASE_PATH if sys.argv[2] == 'device' else USECASE_PATH
    interpolate_dict = {
        'usecase': usecase,
        'repository': repository
    }
    with open(f'{os.path.dirname(__file__)}/usecase.template') as template:
        with open(f'{usecase_path.format(repository)}{usecase}_usecase.dart', 'w') as usecase_file:
            for line in template:
                if line:
                    interpolated = _replace_keys_with_values_from_text(interpolate_dict, line)
                    usecase_file.write(interpolated)


def _snake_case_to_upper_case(text):
    capitalized_texts = map(lambda text: text.capitalize(), text.split('_'))
    return ''.join(capitalized_texts)


def _replace_keys_with_values_from_text(dict, text):
    current_text = text
    for key in dict.keys():
        current_text = current_text.replace(f'${key}$', dict.get(key)) # lower
        current_text = current_text.replace(f'${key.capitalize()}$', _snake_case_to_upper_case(dict.get(key))) # upper

    return current_text


# generate_usecases(['connect', 'disconnect', 'test_print'], 'printer')
generate_from_repository(sys.argv[1])
