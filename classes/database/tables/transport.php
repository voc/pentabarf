<?php

require_once('../classes/database/db_base.php');
require_once('../classes/database/datatypes/dt_varchar.php');
require_once('../classes/database/datatypes/dt_integer.php');
require_once('../classes/database/datatypes/dt_serial.php');

/// class for accessing and manipulating content of table transport
class TRANSPORT extends DB_BASE
{
   /// constructor of the class transport
   public function __construct()
   {
      parent::__construct();
      $this->table = 'transport';
      $this->domain = 'transport';
      $this->limit = 0;
      $this->order = '';

      $this->fields['tag'] = new DT_VARCHAR( $this, 'tag', array('length' => 32), array('NOT_NULL' => true) );
      $this->fields['rank'] = new DT_INTEGER( $this, 'rank', array(), array() );
      $this->fields['transport_id'] = new DT_SERIAL( $this, 'transport_id', array(), array('NOT_NULL' => true, 'PRIMARY_KEY' => true) );
   }

}

?>
