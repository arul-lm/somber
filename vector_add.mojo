from sys import has_accelerator
from sys.param_env import env_get_int
from gpu.host import DeviceContext
from gpu import block_idx, thread_idx, block_dim
from math import ceildiv
from layout import Layout, LayoutTensor

fn print_threads():
    print("Block:[", block_idx.x, "], Thread:[", thread_idx.x, "]")

comptime float_dtype = DType.float32
# These can be overridden: mojo -D vector_size=10000 -D BLOCK_SIZE=128 vector_add.mojo
comptime VECTOR_SIZE: Int = env_get_int["VECTOR_SIZE", 10000]()
comptime BLOCK_SIZE: Int = env_get_int["BLOCK_SIZE", 64]()
comptime NUM_BLOCKS = ceildiv(VECTOR_SIZE, BLOCK_SIZE)
comptime layout = Layout.row_major(VECTOR_SIZE)

fn vector_add(
    lhs: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    rhs: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    result: LayoutTensor[float_dtype, layout, MutAnyOrigin],
):
    var tid = block_idx.x * block_dim.x + thread_idx.x
    if tid < VECTOR_SIZE:
        result[tid] = lhs[tid] + rhs[tid]
    else:
        print("Thread out of bounds", block_idx.x, thread_idx.x)

def main():
    @parameter
    if has_accelerator():
        ctx = DeviceContext()
        print("Found accelerator", ctx.name())
        # Create host buffers for the input vectors
        lhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](VECTOR_SIZE)
        rhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](VECTOR_SIZE)
        ctx.synchronize()
        # Fill the host buffers with data
        for i in range(VECTOR_SIZE):
            lhs_host_buffer[i] = Float32(i)
            rhs_host_buffer[i] = Float32(Float64(i) * 0.5)
        # Create device buffers for the input vectors
        lhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](VECTOR_SIZE)
        rhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](VECTOR_SIZE)
        # Copy data from host to device
        ctx.enqueue_copy(dst_buf=lhs_device_buffer, src_buf=lhs_host_buffer)
        ctx.enqueue_copy(dst_buf=rhs_device_buffer, src_buf=rhs_host_buffer)
        # Create a device buffer for the result vector
        result_device_buffer = ctx.enqueue_create_buffer[float_dtype](
            VECTOR_SIZE
        )
        result_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](VECTOR_SIZE)

        lhs_tensor = LayoutTensor[float_dtype, layout](lhs_device_buffer)
        rhs_tensor = LayoutTensor[float_dtype, layout](rhs_device_buffer)
        result_tensor = LayoutTensor[float_dtype, layout](result_device_buffer)

        ctx.enqueue_function[vector_add, vector_add](
            lhs_tensor,
            rhs_tensor,
            result_tensor,
            grid_dim=NUM_BLOCKS,
            block_dim=BLOCK_SIZE,
        )
        ctx.enqueue_copy(dst_buf=result_host_buffer, src_buf=result_device_buffer)
        ctx.synchronize()

        print("LHS:", lhs_host_buffer)
        print("RHS:", rhs_host_buffer)
        print("Result:", result_host_buffer)
    else:
        print("No accelerator found")