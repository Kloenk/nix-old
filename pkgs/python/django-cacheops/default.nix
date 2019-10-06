{ lib, buildPythonPackage, fetchPypi
, django }:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05lz1s0ji5p9lybs1s6925k83y1y43rj6ysb05n1pdmi9snrbsjn";
  };

  checkInputs = [ django ];

  meta = with lib; {
    description = "A slick app that supports automatic or manual queryset caching and automatic granular event-driven invalidation";
    homepage = https://github.com/Suor/django-cacheops;
    license = licenses.unredistributal.nonFree;
    #maintainers = with maintainers; [ kloenk ];
  };
}