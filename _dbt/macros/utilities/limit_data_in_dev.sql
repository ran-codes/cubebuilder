
{# 
  Recomended settings
    - Development: x = 1000
    - Light weight test: x = 100000
    - Heavy weight test: x = 1000000
    - Super heavy weight tests: x = 20000000
#}

{% macro limit_data_in_dev(x = 100000) %}
  {% if 'dev' in target.name %}
    {% if x < 100000 %}
      ORDER BY RANDOM()
    {% endif %}
    LIMIT {{ x }}
  {% endif %}
{% endmacro %}