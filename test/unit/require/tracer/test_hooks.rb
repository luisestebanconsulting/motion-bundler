require File.expand_path("../../../../test_helper", __FILE__)

module Unit
  module Require
    module Tracer
      class TestHooks < MiniTest::Unit::TestCase

        describe MotionBundler::Require::Tracer::Hooks do
          it "should hook into core methods" do
            assert_equal false, Kernel.respond_to?(:require_with_mb_trace)
            assert_equal false, Object.respond_to?(:require_with_mb_trace)
            assert_equal false, Kernel.respond_to?(:require_relative_with_mb_trace)
            assert_equal false, Object.respond_to?(:require_relative_with_mb_trace)
            assert_equal false, Kernel.respond_to?(:load_with_mb_trace)
            assert_equal false, Object.respond_to?(:load_with_mb_trace)

            MotionBundler::Require::Tracer.hook
            assert_equal true, Kernel.respond_to?(:require_with_mb_trace)
            assert_equal true, Object.respond_to?(:require_with_mb_trace)
            assert_equal true, Kernel.respond_to?(:require_relative_with_mb_trace)
            assert_equal true, Object.respond_to?(:require_relative_with_mb_trace)
            assert_equal true, Kernel.respond_to?(:load_with_mb_trace)
            assert_equal true, Object.respond_to?(:load_with_mb_trace)

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'", "a")
            require "a"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'", "../../../lib/b")
            require_relative "../../../lib/b"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 1}:in `block (2 levels) in <class:TestHooks>'", "c.rb")
            load "c.rb"

            MotionBundler::Require::Tracer.log.expects(:register).with("#{__FILE__}:#{__LINE__ + 2}:in `<module:SlotMachine>'", gem_path("slot_machine/lib/slot_machine/version"))
            module ::SlotMachine
              autoload :VERSION, gem_path("slot_machine/lib/slot_machine/version")
            end

            MotionBundler::Require::Tracer.unhook
            assert_equal false, Kernel.respond_to?(:require_with_mb_trace)
            assert_equal false, Object.respond_to?(:require_with_mb_trace)
            assert_equal false, Kernel.respond_to?(:require_relative_with_mb_trace)
            assert_equal false, Object.respond_to?(:require_relative_with_mb_trace)
            assert_equal false, Kernel.respond_to?(:load_with_mb_trace)
            assert_equal false, Object.respond_to?(:load_with_mb_trace)
          end
        end

      end
    end
  end
end