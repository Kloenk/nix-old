{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption types;
  inherit (lib) mapAttrsToList optional optionalString;

  cfg = config.services.engelsystem;
  fpm = config.services.phpfpm.pools.engelsystem;

  user = "engelsystem";
  stateDir = "/var/lib/engelsystem";

 # databaseOpts = {
 #   options = {
 #     host = mkOption {
 #       type = types.str;
 #       default = "localhost";
 #       description = "Database host address";
 #     };

 #     name = mkOption {
 #       type = types.str;
 #       default = "engelsystem";
 #       description = "Database name";
 #     };

 #     user = mkOption {
 #       
 #     }
 #   };
 # };

  esConfig = pkgs.writeText "config.php" ''
  	<?php

  	return [
  	  'database' => [
  	    'host' => '${cfg.database.host}',
  	    'database' => '${cfg.database.name}',
  	    'username' => '${cfg.database.user}',
        'password' => '${cfg.database.password}', // password file
  	  ],
  	  'api_key' => '${cfg.apiKey}',
  	  'maintenance' => ${cfg.maintenance},
  	  'app_name' => '${cfg.name}',
  	  'environment' => '${cfg.environment}',
  	  'header_items' => [
  	  	// lib.map???
  	  ],
  	  'footer_items' => [
  	  	// lib.map???
  	  ],
  	  'documentation_url' => '${cfg.documentationUrl}',
  	  'email' => [
  	  	'driver' => '${cfg.mail.driver}',
  	  	'from' => [
  	  		'address' => '${cfg.mail.fromAddress}',
  	  		'name' => '${cfg.mail.fromName}',
  	  	],
  	  	'host' => '${cfg.mail.host}',
  	  	'port' => '${toString cfg.mail.port}',
  	  	'username' => '${cfg.mail.user}',
  	  	'password' => '${cfg.mail.password}', // password file
  	    'sendmail' => '${cfg.mail.sendmail}',
  	  ],
  	  'theme' => '${cfg.theme}',
  	  'available_themes'        => [
        '12' => 'Engelsystem 36c3 (2019)',
        '10' => 'Engelsystem cccamp19 green (2019)',
        '9' => 'Engelsystem cccamp19 yellow (2019)',
        '8' => 'Engelsystem cccamp19 blue (2019)',
        '7' => 'Engelsystem 35c3 dark (2018)',
        '6' => 'Engelsystem 34c3 dark (2017)',
        '5' => 'Engelsystem 34c3 light (2017)',
        '4' => 'Engelsystem 33c3 (2016)',
        '3' => 'Engelsystem 32c3 (2015)',
        '2' => 'Engelsystem cccamp15',
        '11' => 'Engelsystem high contrast',
        '0' => 'Engelsystem light',
        '1' => 'Engelsystem dark',
      ],
      'rewrite_urls' => ${cfg.rewriteUrls},
      'home_site' => '${cfg.homeSite}',
      'display_news' => ${toString cfg.displayNews},
      'registration_enabled' => ${cfg.registration},
      'signup_requires_arrival' => ${cfg.singup},
      'autoarrive' => ${cfg.autoarrive},
      'signup_advance_hours' => ${toString cfg.advanceHours},
      'last_unsubscribe' => ${toString cfg.unsubscribe},
      'password_algorithm'  => PASSWORD_DEFAULT,
      'min_password_length' => ${toString cfg.passwordLength},
      'enable_dect' => ${toString cfg.dect},
      'enable_user_name' => ${toString cfg.userNames},
      'enable_promoun' => ${toString cfg.pronoun},
      'enable_planned_arrival' => ${toString cfg.arrival},
      'enable_tshirt_size' => ${toString cfg.tshirt},
      'max_freelodable_shifts' => ${toString cfg.freelodable},
      'timezone' => '${cfg.timezone}',
      'night_shifts' => [
      	'enabled' => ${toString cfg.nightShifts.enable},
      	'start' => ${toString cfg.nightShifts.start},
      	'end' => ${toString cfg.nightShifts.end},
      	'multiplier' => ${toString cfg.nightShifts.multiplier},
      ],
      'voucher_settings' => [
      	'initial_vouchers' => ${toString cfg.voucher.initial},
      	'shifts_per_voucher' => ${toString cfg.voucher.perShift},
      	'hours_per_voucher' => ${toString cfg.voucher.perHours},
      	'voucher_start' => ${if cfg.voucher.start == null then "null" else "'${cfg.voucher.start}'" }
      ],
      'locales' => [
        'de_DE' => 'Deutsch',
        'en_US' => 'English',
      ],
      'default_locale' => '${cfg.locale}',
      'tshirt_sizes'            => [
        'S'    => 'Small Straight-Cut',
        'S-G'  => 'Small Fitted-Cut',
        'M'    => 'Medium Straight-Cut',
        'M-G'  => 'Medium Fitted-Cut',
        'L'    => 'Large Straight-Cut',
        'L-G'  => 'Large Fitted-Cut',
        'XL'   => 'XLarge Straight-Cut',
        'XL-G' => 'XLarge Fitted-Cut',
        '2XL'  => '2XLarge Straight-Cut',
        '3XL'  => '3XLarge Straight-Cut',
        '4XL'  => '4XLarge Straight-Cut',
      ],
      'filter_max_duration' => ${toString cfg.filter}',
      'session'                 => [
        'driver' => env('SESSION_DRIVER', 'pdo'),
        'name'   => 'session',
      ],
      'trusted_proxies'         => '${cfg.trustedProxies}',
      'add_headers'             => ${toString cfg.addHeaders},
      'headers'                 => [
        'X-Content-Type-Options'  => 'nosniff',
        'X-Frame-Options'         => 'sameorigin',
        'Referrer-Policy'         => 'strict-origin-when-cross-origin',
        'Content-Security-Policy' => 'default-src \\'self\\' \\'unsafe-inline\\' \\'unsafe-eval\\'\',
        'X-XSS-Protection'        => '1; mode=block',
        'Feature-Policy'          => 'autoplay \\'none\\'\',
      ],
      'credits'                 => [
         'Contribution' => 'Please visit [engelsystem/engelsystem](https://github.com/engelsystem/engelsystem) if '
              . 'you want to to contribute, have found any [bugs](https://github.com/engelsystem/engelsystem/issues) '
              . 'or need help.'
      ]
    ];
  '';
in {
  # interface
  options.services.engelsystem = {
    enable = mkEnableOption "Engelsystem web application";

    database = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address";
      };
      name = mkOption {
        type = types.str;
        default = "engelsystem";
        description = "Database name";
      };
      user = mkOption {
        type = types.str;
        default = "engelsystem";
        description = "Database user";
      };
      password = mkOption {
        type = types.nullOr types.str;
        description = "Database password";
      };
      # passwordFile = mkOption ...
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally";
      };
    };
  };

}
