<?php
class simpleWidget extends WP_Widget {
    function __construct() {
        parent::__construct( false, 'Kirivo - Simple widget' );
    }

    function widget( $args, $instance ) { ?>
        <div>
            <h1>Titolo del widget : <?php echo $instance['title']?></h1>
        </div>
        <?php
    }

    function form( $instance ) {?>
        <p>
            <label for="<?php echo $this->get_field_id('title'); ?>"
            'Titolo:');</label>
            <input id="<?php echo $this->get_field_id('title');?>" 
            name="<?php echo $this->get_field_name( 'title' ); ?>" 
            type="text" value="<?php echo $instance['title']; ?>" />
        </p>
        <?php
    }
}