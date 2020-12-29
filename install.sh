composer.phar require slim/slim "^4.7"
composer.phar require illuminate/database "^8.20"
composer.phar require slim/psr7 "^1.3"
echo "RewriteEngine On\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteRule ^ index.php [QSA,L]" > .htaccess
echo '<?php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
require "vendor/autoload.php";
require "bootstrap.php";

use Mainclass\Models\Usuario;
	use Mainclass\Middleware\Logging as Logging;


$app = AppFactory::create();
//$app->setBasePath("/mw"); //si se está usando en un subdir
$app->addErrorMiddleware(true, false, false);
$app->get("/", function (Request $request, Response $response, array $args) {
    $response->getBody()->write("Hello World");
    $usuario = new Usuario();
    $usuarios = $usuario->all();
    return $response;
});
$app->run();'> index.php
echo '<?php
	include "config/credentials.php";
	include "vendor/autoload.php";
	use Illuminate\Database\Capsule\Manager as Capsule;

	$capsule = new Capsule();
	$capsule->addConnection([
		"driver"    => "mysql",
		"host"      => $db_host,
		"database"  => $db_name,
		"username"  => $db_user,
		"password"  => $db_pass,
		"charset"   => "utf8",
		"collation" => "utf8_general_ci",
		"prefix"    => ""
	]);
	$capsule->bootEloquent();' > bootstrap.php
mkdir config
cd config
echo '<?php
		$db_host = "127.0.0.1";
		$db_name = "middleware";
		$db_user = "root";
		$db_pass = "root";' > credentials.php
cd ..
mkdir src
cd src
mkdir Mainclass
cd Mainclass
mkdir Middleware
cd Middleware
echo '<?php
	namespace Mainclass\Middleware;
	class Logging{
		public function __invoke($request, $response, $next){
			error_log($request->getMethod() . " -- ". $request->getUri());
			$response = $next($request, $response);
			return $response;
		}
	}' > Logging.php
cd ..
mkdir Models
cd Models
echo '<?php
	namespace Mainclass\Models;
	class Usuario extends \Illuminate\Database\Eloquent\Model{

	}'> Usuario.php
cd ../../../
echo '{
    "require": {
        "slim/slim": "^4.7",
        "illuminate/database": "^8.20",
		"slim/psr7": "^1.3"
    },
    "autoload" : {
		"psr-4" : {"Mainclass\\\" : "src/Mainclass/"}
    }
}
' > composer.json
composer.phar update