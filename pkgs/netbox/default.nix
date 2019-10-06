{ lib
, python
, fetchFromGitHub
/* , django
, django-cacheops
, django-cors-headers
, django-debug-toolbar
, django-filter
, django-mptt
, django-prometheus
, django-rq
, django-tables2
, django-taggit
, django-taggit-serializer
, django-timezone-field
, djangorestframework
, drf-yasg
, graphviz
, jinja2
, markdown
, netaddr
, pillow
, psycopg2
, py-gfm
, pycryptodome */
}:

python.pkgs.buildPythonApplication rec {
  pname = "netbox";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox";
    rev = "v${version}";
    sha256 = "0k1xg430sfqqhl2klmlndlv37zvbiyq011li43crppiv2csc0l37";
  };

  doCheck = false;
  
  propagatedBuildInputs = with python.pkgs; [
    django
    django-cacheops
    django-cors-headers
    django-debug-toolbar
    django-filter
    django-mptt
    django-prometheus
    django-rq
    django-tables2
    django-taggit
    django-taggit-serializer
    django-timezone-field
    djangorestframework
    drf-yasg
    graphviz
    jinja2
    markdown
    netaddr
    pillow
    psycopg2
    py-gfm
    pycryptodome
  ];

  meta = with lib; {
    #homepage = https://github.com/pytoolz/toolz;
    description = "pytradfri module";
    license = licenses.apache2;
  };
}
