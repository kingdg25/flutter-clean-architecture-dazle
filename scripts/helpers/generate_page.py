import sys
import os


view_path = './lib/app/pages/{0}/{0}_view.dart'
view_template_path = f'{os.path.dirname(__file__)}/view.template'

controller_path = './lib/app/pages/{0}/{0}_controller.dart'
controller_template_path = f'{os.path.dirname(__file__)}/controller.template'

presenter_path = './lib/app/pages/{0}/{0}_presenter.dart'
presenter_template_path = f'{os.path.dirname(__file__)}/presenter.template'


def generate_page(page_name):
    """
    Run using `python3 script/helpers/generate_page.py <page_name>`
    """
    try:
        os.mkdir('./lib/app/pages/{0}'.format(page_name))
        _generate_view(page_name)
        _generate_presenter(page_name)
        _generate_controller(page_name)
    except OSError:
        print('Unable to create new directory')


def _generate_view(view_name):
    interpolation = {
        '%sc%': view_name,
        '%pc%': _snake_case_to_upper_case(view_name)
    }
    with open(view_template_path) as template_file:
        with open(view_path.format(view_name), 'w') as view_file:
            for line in template_file:
                if line:
                    interpolated = _replace_keys_with_values_from_text(interpolation, line)
                    view_file.write(interpolated)


def _generate_presenter(presenter_name):
    interpolation = {
        '%sc%': presenter_name,
        '%pc%': _snake_case_to_upper_case(presenter_name)
    }
    with open(presenter_template_path) as template_file:
        with open(presenter_path.format(presenter_name), 'w') as presenter_file:
            for line in template_file:
                if line:
                    interpolated = _replace_keys_with_values_from_text(interpolation, line)
                    presenter_file.write(interpolated)


def _generate_controller(controller_name):
    interpolation = {
        '%sc%': controller_name,
        '%pc%': _snake_case_to_upper_case(controller_name)
    }
    with open(controller_template_path) as template_file:
        with open(controller_path.format(controller_name), 'w') as controller_file:
            for line in template_file:
                if line:
                    interpolated = _replace_keys_with_values_from_text(interpolation, line)
                    controller_file.write(interpolated)


def _snake_case_to_upper_case(text):
    capitalized_texts = map(lambda text: text.capitalize(), text.split('_'))
    return ''.join(capitalized_texts)


def _replace_keys_with_values_from_text(dict, text):
    current_text = text
    for key in dict.keys():
        current_text = current_text.replace(key, dict.get(key))
    return current_text


generate_page(sys.argv[1])

